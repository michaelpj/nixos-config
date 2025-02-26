self: super:
{
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

  # the aider derivation itself does an override, which means we can't get the grep-ast
  # bump in with an override ourselves, so we sneak it in this way
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (python-self: python-super: {
      grep-ast = python-super.grep-ast.overridePythonAttrs (oldAttrs: rec {
        version = "0.6.1";

        src = super.fetchPypi {
          inherit version;
          pname = "grep_ast";
          hash = "sha256-uQRYCpkUl6/UE1xRohfQAbJwhjI7x1KWc6HdQAPuJNA=";
        };
      });
    }
    )
  ];

  python312 = super.python312.override {
    packageOverrides = python-self: python-super: {
      aider-chat = python-super.aider-chat.overridePythonAttrs (oldAttrs: rec {
        version = "0.75.1";
        src = super.fetchFromGitHub {
          owner = "Aider-AI";
          repo = "aider";
          tag = "v${version}";
          hash = "sha256-TQDYrkSW58E1/lIBuJsgpXst8OAbaTyNX1SM8mdFgzU=";
        };
        dependencies = oldAttrs.dependencies ++ [ python-super.socksio ];
      });
    };
  };
}
