{ config, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;

  services.xserver = {
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };

  programs.kdeconnect.enable = true;
  environment.systemPackages = [ 
    # this doesn't do much, but makes it easier to see the settings
    pkgs.sddm-kcm
  ];
}
