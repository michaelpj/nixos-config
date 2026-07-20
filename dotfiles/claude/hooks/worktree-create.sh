#!/usr/bin/env bash
# Claude Code WorktreeCreate hook: create worktrees with a hot cabal
# build cache where possible.
#
# Fast path: delegate to worktree-add (../../bin in this dotfiles
# repo), which creates a jj workspace — or, in a plain git repo, a
# detached git worktree — at ~/wt/<pad>/<name> and relocates a copy of
# the parent's dist-newstyle so cabal is immediately "Up to date"; see
# Note [Relocating dist-newstyle] in that script. Repos without a
# dist-newstyle still take this path (the seeding steps are no-ops).
#
# Fallback (worktree-add missing, or it failed — e.g. the repo root
# path is too short to build the length-matched target): plain
# worktree at .claude/worktrees/<name> inside the repo, seeded with a
# non-relocated cache copy.
set -euo pipefail

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r '.name')
CWD=$(echo "$INPUT" | jq -r '.cwd')

# readlink -f: this hook is deployed as a symlink into the dotfiles
# checkout, so resolve to the real file before locating siblings.
WORKTREE_ADD="$(dirname "$(readlink -f "$0")")/../../bin/worktree-add"
if [ -x "$WORKTREE_ADD" ]; then
    if TARGET=$(cd "$CWD" && "$WORKTREE_ADD" "${NAME//\//-}"); then
        echo "$TARGET"
        exit 0
    fi
fi

# A .gitignore with !* is placed inside to override the parent repo's
# .gitignore which ignores this directory — this is needed so that nix's
# gitignoreSource doesn't filter out the worktree's source files.
WORKTREE_PATH="$CWD/.claude/worktrees/$NAME"
mkdir -p "$(dirname "$WORKTREE_PATH")"
echo '!*' > "$CWD/.claude/worktrees/.gitignore"

if [ -d "$CWD/.jj" ]; then
    # Create a jj workspace instead of a git worktree
    jj --repository "$CWD" workspace add --name "$NAME" "$WORKTREE_PATH"
else
    # Fall back to standard git worktree
    git -C "$CWD" worktree add "$WORKTREE_PATH"
fi

# If source repo has dist-newstyle, reflink-copy it into the worktree.
# -a (not -r): preserving mtimes is essential — GHC's object-freshness
# check is mtime-based (.o/.dyn_o must not be older than .hi), and a
# re-stamping copy makes most modules recompile.
if [ -d "$CWD/dist-newstyle" ]; then
    cp --reflink=auto -a "$CWD/dist-newstyle" "$WORKTREE_PATH/dist-newstyle"
fi

# cabal.project.local is typically gitignored, so the worktree won't
# have it — but it feeds cabal's configuration.
if [ -f "$CWD/cabal.project.local" ] && [ ! -e "$WORKTREE_PATH/cabal.project.local" ]; then
    cp "$CWD/cabal.project.local" "$WORKTREE_PATH/"
fi

# Hook must output the worktree path
echo "$WORKTREE_PATH"
