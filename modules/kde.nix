{ config, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  services = {
    displayManager.plasma-login-manager = {
      enable = true;
      enableHidpi = true;
      wayland.enable = true;
    };
  };

  programs.kdeconnect.enable = true;
}
