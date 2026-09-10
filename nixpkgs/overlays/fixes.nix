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
      self.libxcb
    ];
  };

  # nix-direnv 3.2.0 touches the cached nix-profile-*.rc on every load
  # (gcroot refresh), which direnv watches, so multiple shells in the same
  # directory reload each other forever. Fixed upstream by
  # https://github.com/nix-community/nix-direnv/pull/790 (nix-direnv issue
  # #786) but not yet in a tagged release. Drop this once nixpkgs ships a
  # version newer than 3.2.0.
  nix-direnv = super.nix-direnv.override {
    fetchFromGitHub =
      args:
      super.fetchFromGitHub (
        builtins.removeAttrs args [ "tag" ]
        // {
          rev = "8c7ebb294d997bc1720ddf3f7ee9ed27c290a0e6";
          hash = "sha256-nizx6hDPX8P9/M7GWLunnnQpyPJed1ZzKuNDnU+R4Oc=";
        }
      );
  };
}
