{ config, pkgs, ... }:
{
  services.xserver = {
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      theme = "sugar-dark";
    };
  };

  environment.systemPackages = let themes = pkgs.callPackage ../nixpkgs/pkgs/sddm-themes.nix {}; in [ 
    pkgs.kdeconnect 
    # this doesn't do much, but makes it easier to see the settings
    pkgs.sddm-kcm
    themes.sddm-sugar-dark 
  ];
}
