{ claudeCodePackageLock }: self: super:
let
  claudeCodeVersion = "2.1.92";
  claudeCodeSrc = super.fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${claudeCodeVersion}.tgz";
    hash = "sha256-CLLCtVK3TeXFZ8wBnRRHNc2MoUt7lTdMJwz8sZHpkFM=";
  };
in
{
  # Update claude-code to 2.1.92
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
      hash = "sha256-5LvH7fG5pti2SiXHQqgRxfFpxaXxzrmGxIoPR4dGE+8=";
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
