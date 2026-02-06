let
  claudeCodePackageLock = ./overlays/claude-code-package-lock.json;
in
[
  (import ./overlays/configs.nix)
  (import ./overlays/fixes.nix { inherit claudeCodePackageLock; })
]
