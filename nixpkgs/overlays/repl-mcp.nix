{ replMcpPackageLock }: self: super:

let
  replMcpVersion = "0.4.1";
  replMcpSrc = super.fetchFromGitHub {
    owner = "takafu";
    repo = "repl-mcp";
    rev = "v${replMcpVersion}";
    hash = "sha256-ZvjF0U/a5y8zI42KE94wUxXUj7xCvF8wwQo1SQwAL0A=";
  };
in
{
  repl-mcp = super.buildNpmPackage {
    pname = "repl-mcp";
    version = replMcpVersion;

    src = replMcpSrc;

    postPatch = ''
      cp ${replMcpPackageLock} package-lock.json
    '';

    npmDepsHash = "sha256-KFi9JjXlcWPAVVjl3uq1PURf+priQgww6MP7QBLRP18=";
    makeCacheWritable = true;
    forceGitDeps = true;

    # node-pty's post-install script uses `npx node-gyp` which fails in the
    # sandbox. Skip all scripts during rebuild, then build node-pty manually.
    npmRebuildFlags = [ "--ignore-scripts" ];

    preBuild = ''
      # Build node-pty: native addon + TypeScript compilation
      cd node_modules/node-pty
      node-gyp rebuild
      # Compile TS source only. The git HEAD version of node-pty has minor
      # type errors with newer Node types (safe at runtime), so we disable
      # composite mode and allow emit despite errors.
      ${super.lib.getExe super.jq} '
        .exclude += ["**/*.test.ts"] |
        .compilerOptions.composite = false |
        .compilerOptions.noEmitOnError = false |
        .compilerOptions.skipLibCheck = true
      ' src/tsconfig.json > src/tsconfig.tmp.json
      mv src/tsconfig.tmp.json src/tsconfig.json
      npx tsc -p ./src/tsconfig.json --noEmitOnError false --skipLibCheck || true
      # Verify that lib/ was actually generated
      test -f lib/index.js || { echo "ERROR: node-pty lib/ not generated"; exit 1; }
      cd ../..
    '';

    # node-pty requires native compilation via node-gyp
    nativeBuildInputs = with super; [
      python3
      pkg-config
      nodePackages.node-gyp
    ];

    # node-pty links against libuv
    buildInputs = with super; [
      libuv
    ];

    meta = {
      description = "Universal REPL session manager MCP server";
      homepage = "https://github.com/takafu/repl-mcp";
      license = super.lib.licenses.mit;
      mainProgram = "repl-mcp";
    };
  };
}
