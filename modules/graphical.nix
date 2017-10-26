{ config, pkgs, ... }:

{
  imports = [ ./kde.nix ];
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "caps:escape";
  };

  boot.plymouth = {
    enable = true;
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  services.tzupdate.enable = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      dejavu_fonts
      iosevka
    ];
  };

  environment.systemPackages = with pkgs; [
    numix-icon-theme papirus-icon-theme arc-icon-theme
    networkmanagerapplet
  ];
}
