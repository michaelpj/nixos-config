#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path // .path // empty')

if [ -z "$WORKTREE_PATH" ]; then
    echo "No worktree path provided" >&2
    exit 1
fi

# Forget the workspace/worktree from inside it — no need to know the parent repo
if [ -d "$WORKTREE_PATH/.jj" ]; then
    jj -R "$WORKTREE_PATH" workspace forget 2>/dev/null || true
    rm -rf "$WORKTREE_PATH"
elif [ -e "$WORKTREE_PATH/.git" ]; then
    # For git worktrees, .git is a file pointing to the main repo
    git -C "$WORKTREE_PATH" worktree remove --force "$WORKTREE_PATH" 2>/dev/null || true
fi

# Hot-cache worktrees live under a padding directory (~/wt/<pad>/<name>,
# see worktree-add); remove it too once empty.
rmdir --ignore-fail-on-non-empty "$(dirname "$WORKTREE_PATH")" 2>/dev/null || true
