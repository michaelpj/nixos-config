{ config, pkgs, ... }:
{
  services.xserver = {
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };
  environment.systemPackages = [ pkgs.kdeconnect ];
}
