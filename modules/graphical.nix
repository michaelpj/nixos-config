{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "caps:escape";
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
    };
  };

  boot.plymouth = {
    enable = true;
  };

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  environment.systemPackages = with pkgs; [
    numix-gtk-theme numix-icon-theme
  ];
}
