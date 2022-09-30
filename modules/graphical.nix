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

  location = {
    provider = "geoclue2";
  };

  # broken due to geoclue being stupid
  #services.localtime.enable = true;

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      dejavu_fonts
      iosevka-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    numix-icon-theme papirus-icon-theme arc-icon-theme
  ];
}
