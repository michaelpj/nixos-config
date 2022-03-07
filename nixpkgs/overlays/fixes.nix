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
}
