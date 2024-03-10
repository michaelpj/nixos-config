{ config, pkgs, ... }:
{
  services.xserver = {
    desktopManager.plasma6.enable = true;
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
