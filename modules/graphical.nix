{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "caps:escape";
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  services.redshift = {
    enable = true;
    latitude = "51";
    longitude = "1";
  };
  
  environment.systemPackages = with pkgs; [
    numix-gtk-theme numix-icon-theme
  ];
}
