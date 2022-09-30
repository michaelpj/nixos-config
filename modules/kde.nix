{ config, pkgs, ... }:
{
  services.xserver = {
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
    };
  };

  environment.systemPackages = [ 
    pkgs.plasma5Packages.kdeconnect-kde
    # this doesn't do much, but makes it easier to see the settings
    pkgs.sddm-kcm
  ];
}
