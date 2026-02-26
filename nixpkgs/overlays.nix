let
  claudeCodePackageLock = ./overlays/claude-code-package-lock.json;
  replMcpPackageLock = ./overlays/repl-mcp-package-lock.json;
in
[
  (import ./overlays/configs.nix)
  (import ./overlays/donethat.nix)
  (import ./overlays/fixes.nix { inherit claudeCodePackageLock; })
  (import ./overlays/via.nix)
  (import ./overlays/repl-mcp.nix { inherit replMcpPackageLock; })
]
