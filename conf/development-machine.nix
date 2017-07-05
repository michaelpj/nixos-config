{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkgconfig python ruby
    # utilities
    wget unzip rsync
    # desktop
    firefox
    networkmanagerapplet
    xscreensaver
    spotify
    tilda
    gnome3.gconf
    steam
    evince
  ];

  virtualisation.virtualbox.host.enable = true;

  services = {
    keybase.enable = true;

    kbfs = {
      enable = true;
      mountPoint = "/keybase";
    };

    arbtt.enable = true;

    redshift = {
      enable = true;
      latitude = "51";
      longitude = "1";
    };

    printing.enable = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      dejavu_fonts
    ];
  };
}
