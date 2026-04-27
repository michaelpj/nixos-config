{ config, pkgs, ... }:

{
  imports = [ ./kde.nix ];
  services.xserver = {
    enable = true;
    xkb = {
      layout = "gb";
      options = "caps:escape";
    };
  };

  boot.plymouth = {
    enable = true;
  };

  # Provides geoclue-based location lookup. Consumed by KDE's geotimezoned
  # kded module for automatic timezone updates (enabled per-user in home.nix).
  # Note: beacondb (the default WiFi geoprovider) often has no data for local
  # APs, so geoclue falls back to ~25km IP-based accuracy. That's fine for
  # timezones, but means the result follows the public egress IP — a VPN
  # (e.g. Mullvad) on a foreign server can make it pick the wrong zone.
  location = {
    provider = "geoclue2";
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      dejavu_fonts
      iosevka-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    numix-icon-theme
    papirus-icon-theme
    arc-icon-theme
  ];
}
