{ claudeCodePackageLock }: self: super:
let
  claudeCodeVersion = "2.1.72";
  claudeCodeSrc = super.fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${claudeCodeVersion}.tgz";
    hash = "sha256-sSIjVW0DWb/rTv0AN7ineU4h45jnzFfElqkr1/+wWAk=";
  };
in
{
  # Update claude-code to 2.1.72
  claude-code = super.claude-code.overrideAttrs (oldAttrs: {
    version = claudeCodeVersion;
    src = claudeCodeSrc;
    postPatch = ''
      cp ${claudeCodePackageLock} package-lock.json
      substituteInPlace cli.js \
        --replace-warn '#!/bin/bash' '#!/usr/bin/env bash'
    '';
    npmDeps = super.fetchNpmDeps {
      name = "claude-code-${claudeCodeVersion}-npm-deps";
      src = claudeCodeSrc;
      postPatch = ''
        cp ${claudeCodePackageLock} package-lock.json
      '';
      hash = "sha256-Pd/UZU9opWg7pEFfISLTHN5Gc08+E1x6ip3YzkRkV7w=";
    };
  });

  steam = super.steam.override {
    extraPkgs = p: [
      self.gtk3
      self.atk
      self.at-spi2-atk
      self.zlib
      self.glib
      self.fontconfig
      self.freetype
      self.dbus
      self.cairo
      self.gdk-pixbuf
      self.pango
      self.xorg.libxcb
    ];
  };
}
