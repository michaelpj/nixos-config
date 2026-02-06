{ claudeCodePackageLock }: self: super:
let
  claudeCodeVersion = "2.1.33";
  claudeCodeSrc = super.fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${claudeCodeVersion}.tgz";
    hash = "sha256-OXbMQVnfRX6Y9WF+nBpKO1Lj0ZXbmefMBuONkSxwEGw=";
  };
in
{
  # Update claude-code to 2.1.33
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
      hash = "sha256-V7Cj6bqg1mOi9lXbSS36+lENylN0XZG03hiJNZw2IEk=";
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
