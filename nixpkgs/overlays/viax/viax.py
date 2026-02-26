#!/usr/bin/env python3
"""viax — tmux-backed REPL supervision CLI.

Manages named REPL sessions inside tmux panes, providing prompt-aware
`ask` semantics for agent tooling.

Exit codes: 0 success, 1 error, 2 timeout.
"""

import argparse
import json
import os
import re
import shlex
import subprocess
import sys
import tempfile
import time

# ---------------------------------------------------------------------------
# State management
# ---------------------------------------------------------------------------

def _state_dir():
    """Return (and ensure) the directory for viax state files."""
    base = os.environ.get("XDG_RUNTIME_DIR")
    if not base:
        base = f"/tmp/viax-{os.getuid()}"
    d = os.path.join(base, "viax")
    os.makedirs(d, exist_ok=True)
    return d


def _state_path():
    return os.path.join(_state_dir(), "sessions.json")


def _load_state():
    p = _state_path()
    if os.path.exists(p):
        with open(p) as f:
            return json.load(f)
    return {}


def _save_state(state):
    p = _state_path()
    with open(p, "w") as f:
        json.dump(state, f, indent=2)
        f.write("\n")


# ---------------------------------------------------------------------------
# tmux helpers
# ---------------------------------------------------------------------------

def _tmux(*args, check=True, capture=True):
    """Run a tmux command, returning stdout."""
    cmd = ["tmux"] + list(args)
    r = subprocess.run(cmd, capture_output=capture, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(f"tmux command failed: {' '.join(cmd)}\n{r.stderr.strip()}")
    return r.stdout if capture else ""


def _pane_exists(pane_id):
    """Check whether a tmux pane is still alive."""
    try:
        _tmux("display-message", "-p", "-t", pane_id, "#{pane_id}")
        return True
    except RuntimeError:
        return False


def _capture_pane(pane_id, full=False):
    """Capture the visible pane content (or full history with -S -)."""
    args = ["capture-pane", "-p", "-t", pane_id]
    if full:
        args += ["-S", "-"]
    return _tmux(*args)


def _matches_prompt(line, prompt_regex):
    """Check if a line matches the prompt regex.

    tmux capture-pane strips trailing whitespace from lines, so prompts
    like ">>> " appear as ">>>". We try matching both the stripped line
    and with a trailing space appended, so regexes like '>>> $' work.
    """
    stripped = line.rstrip()
    if re.search(prompt_regex, stripped):
        return True
    # Retry with trailing space to handle prompts tmux stripped
    if re.search(prompt_regex, stripped + " "):
        return True
    return False


def _write_env_file():
    """Serialize the current environment to a temp file as export statements.

    Returns the path. The caller's pane command should source then delete it.
    """
    fd, path = tempfile.mkstemp(prefix="viax-env-", suffix=".sh", dir=_state_dir())
    with os.fdopen(fd, "w") as f:
        for key, val in os.environ.items():
            f.write(f"export {key}={shlex.quote(val)}\n")
    return path


def _prune_dead(state):
    """Remove sessions whose panes are dead or that have exceeded their idle timeout."""
    now = time.time()
    dead = []
    for name, info in state.items():
        if not _pane_exists(info["pane_id"]):
            dead.append(name)
        elif info.get("idle_timeout") and info.get("last_active"):
            if now - info["last_active"] > info["idle_timeout"]:
                _tmux("kill-pane", "-t", info["pane_id"], check=False)
                dead.append(name)
    for name in dead:
        del state[name]
    if dead:
        _save_state(state)
    return dead


def _touch_session(state, name):
    """Update the last_active timestamp for a session."""
    state[name]["last_active"] = time.time()
    _save_state(state)


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

def cmd_open(args):
    """Open a new REPL session in a tmux pane."""
    state = _load_state()
    _prune_dead(state)
    if args.name in state and _pane_exists(state[args.name]["pane_id"]):
        _die(f"session '{args.name}' already exists")

    command_str = " ".join(args.command)

    # By default, inherit the caller's environment so direnv, PATH, etc.
    # are available in the pane. We write env vars to a temp file that the
    # pane sources (and deletes) before exec-ing the command.
    if not args.no_env:
        env_file = _write_env_file()
        command_str = f"source {shlex.quote(env_file)} && rm -f {shlex.quote(env_file)} && exec {command_str}"

    # Split relative to the invoking pane (not whichever pane is focused).
    # $TMUX_PANE is set by tmux in each pane's environment.
    split_args = ["split-window", "-d", "-P", "-F", "#{pane_id}"]
    caller_pane = os.environ.get("TMUX_PANE")
    if caller_pane:
        split_args += ["-t", caller_pane]
    split_args.append(command_str)
    out = _tmux(*split_args)
    pane_id = out.strip()

    prompt_regex = args.prompt or "^.*[$#>]$"
    entry = {
        "pane_id": pane_id,
        "prompt_regex": prompt_regex,
        "cursor": 0,
        "last_active": time.time(),
    }
    if args.idle_timeout:
        entry["idle_timeout"] = args.idle_timeout
    state[args.name] = entry
    _save_state(state)

    if args.wait:
        # Wait for the prompt to appear
        deadline = time.monotonic() + args.timeout
        while time.monotonic() < deadline:
            content = _capture_pane(pane_id)
            lines = content.rstrip("\n").split("\n") if content.strip() else []
            if lines:
                last = lines[-1]
                if _matches_prompt(last, prompt_regex):
                    # Update cursor to current line count
                    state[args.name]["cursor"] = len(lines)
                    _save_state(state)
                    print(f"session '{args.name}' ready (pane {pane_id})")
                    return
            time.sleep(0.2)
        print(f"timeout waiting for prompt in session '{args.name}'", file=sys.stderr)
        sys.exit(2)

    print(f"session '{args.name}' opened (pane {pane_id})")


def cmd_ask(args):
    """Send input and wait for the prompt, returning the delta output."""
    state = _load_state()
    sess = _get_session(state, args.name)
    _touch_session(state, args.name)
    pane_id = sess["pane_id"]
    prompt_regex = args.prompt or sess["prompt_regex"]
    cursor_before = sess["cursor"]

    # Capture content before sending to know the baseline
    content_before = _capture_pane(pane_id, full=True)
    lines_before = content_before.rstrip("\n").split("\n") if content_before.strip() else []
    cursor_before = len(lines_before)

    # Send the input
    _tmux("send-keys", "-t", pane_id, args.input, "Enter")

    # Poll for prompt
    deadline = time.monotonic() + args.timeout
    while time.monotonic() < deadline:
        time.sleep(0.2)
        content = _capture_pane(pane_id, full=True)
        lines = content.rstrip("\n").split("\n") if content.strip() else []

        if len(lines) <= cursor_before:
            continue

        # Check if the last non-empty line matches the prompt
        last_nonempty = ""
        for line in reversed(lines):
            if line.strip():
                last_nonempty = line
                break

        if _matches_prompt(last_nonempty, prompt_regex):
            # Return the delta: lines between cursor_before and the prompt
            # Exclude the command echo line (cursor_before) and the final prompt line
            delta_lines = lines[cursor_before:]

            # Strip the final prompt line from delta
            if delta_lines and _matches_prompt(delta_lines[-1], prompt_regex):
                delta_lines = delta_lines[:-1]

            # Strip the echoed command (first line of delta is usually the input)
            if delta_lines and args.input.strip() in delta_lines[0]:
                delta_lines = delta_lines[1:]

            # Update cursor
            state[args.name]["cursor"] = len(lines)
            _save_state(state)

            print("\n".join(delta_lines))
            return

    print(f"timeout waiting for prompt in session '{args.name}'", file=sys.stderr)
    sys.exit(2)


def cmd_send(args):
    """Send text without waiting for a response."""
    state = _load_state()
    sess = _get_session(state, args.name)
    _touch_session(state, args.name)
    _tmux("send-keys", "-t", sess["pane_id"], args.text, "Enter")


def cmd_read(args):
    """Read output from a session."""
    state = _load_state()
    sess = _get_session(state, args.name)
    _touch_session(state, args.name)
    pane_id = sess["pane_id"]

    content = _capture_pane(pane_id, full=args.full)
    lines = content.rstrip("\n").split("\n") if content.strip() else []

    if args.delta:
        cursor = sess["cursor"]
        delta = lines[cursor:]
        state[args.name]["cursor"] = len(lines)
        _save_state(state)
        print("\n".join(delta))
    elif args.full:
        print("\n".join(lines))
    else:
        # Default: tail N lines
        tail = lines[-args.tail:] if len(lines) > args.tail else lines
        print("\n".join(tail))


def cmd_interrupt(args):
    """Send Ctrl-C to a session."""
    state = _load_state()
    sess = _get_session(state, args.name)
    _touch_session(state, args.name)
    _tmux("send-keys", "-t", sess["pane_id"], "C-c")
    print(f"sent interrupt to '{args.name}'")


def cmd_close(args):
    """Kill the pane and remove the session."""
    state = _load_state()
    if args.name not in state:
        _die(f"no session named '{args.name}'")

    sess = state[args.name]
    if _pane_exists(sess["pane_id"]):
        _tmux("kill-pane", "-t", sess["pane_id"], check=False)

    del state[args.name]
    _save_state(state)
    print(f"session '{args.name}' closed")


def cmd_close_all(args):
    """Kill all session panes and clear state."""
    state = _load_state()
    if not state:
        print("no active sessions")
        return

    for name, info in state.items():
        if _pane_exists(info["pane_id"]):
            _tmux("kill-pane", "-t", info["pane_id"], check=False)
        print(f"  closed '{name}'")

    _save_state({})
    print(f"closed {len(state)} session(s)")


def cmd_list(args):
    """List active sessions."""
    state = _load_state()
    _prune_dead(state)

    if not state:
        print("no active sessions")
        return

    # Simple table
    name_w = max(len(n) for n in state) + 2
    print(f"{'NAME':<{name_w}} {'PANE':<8} PROMPT")
    for name, info in sorted(state.items()):
        print(f"{name:<{name_w}} {info['pane_id']:<8} {info['prompt_regex']}")


# ---------------------------------------------------------------------------
# Utilities
# ---------------------------------------------------------------------------

def _get_session(state, name):
    """Look up a session by name, validating the pane is alive."""
    if name not in state:
        _die(f"no session named '{name}'")
    sess = state[name]
    if not _pane_exists(sess["pane_id"]):
        del state[name]
        _save_state(state)
        _die(f"session '{name}' pane no longer exists (cleaned up)")
    return sess


def _die(msg):
    print(f"viax: {msg}", file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        prog="viax",
        description="tmux-backed REPL supervision CLI",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    # open
    p_open = sub.add_parser("open", help="Open a session in a tmux pane")
    p_open.add_argument("name", help="Session name")
    p_open.add_argument("command", nargs="+", help="Command to run (after --)")
    p_open.add_argument("--prompt", help="Default prompt regex")
    p_open.add_argument("--wait", action="store_true", help="Wait for initial prompt")
    p_open.add_argument("--timeout", type=float, default=30, help="Timeout for --wait")
    p_open.add_argument("--idle-timeout", type=float, default=0,
                        help="Kill session after N seconds of inactivity (0 = never)")
    p_open.add_argument("--no-env", action="store_true",
                        help="Don't inherit the caller's environment")
    p_open.set_defaults(func=cmd_open)

    # ask
    p_ask = sub.add_parser("ask", help="Send input, wait for prompt, return delta")
    p_ask.add_argument("name", help="Session name")
    p_ask.add_argument("input", help="Input to send")
    p_ask.add_argument("--prompt", help="Override prompt regex")
    p_ask.add_argument("--timeout", type=float, default=30, help="Timeout")
    p_ask.set_defaults(func=cmd_ask)

    # send
    p_send = sub.add_parser("send", help="Send text without waiting")
    p_send.add_argument("name", help="Session name")
    p_send.add_argument("text", help="Text to send")
    p_send.set_defaults(func=cmd_send)

    # read
    p_read = sub.add_parser("read", help="Read output from a session")
    p_read.add_argument("name", help="Session name")
    p_read.add_argument("--delta", action="store_true", help="Only new output since last read/ask")
    p_read.add_argument("--tail", type=int, default=50, help="Last N lines (default: 50)")
    p_read.add_argument("--full", action="store_true", help="Full pane history")
    p_read.set_defaults(func=cmd_read)

    # interrupt
    p_int = sub.add_parser("interrupt", help="Send Ctrl-C")
    p_int.add_argument("name", help="Session name")
    p_int.set_defaults(func=cmd_interrupt)

    # close
    p_close = sub.add_parser("close", help="Kill pane and remove session")
    p_close.add_argument("name", help="Session name")
    p_close.set_defaults(func=cmd_close)

    # close-all
    p_close_all = sub.add_parser("close-all", help="Kill all sessions")
    p_close_all.set_defaults(func=cmd_close_all)

    # list
    p_list = sub.add_parser("list", help="List active sessions")
    p_list.set_defaults(func=cmd_list)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
