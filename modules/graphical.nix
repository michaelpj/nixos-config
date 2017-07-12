{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "gb";
    xkbOptions = "caps:escape";
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
  };

  services.redshift = {
    enable = true;
    latitude = "51";
    longitude = "1";
  };
  
  environment.systemPackages = with pkgs; [
    xfce.xfwm4themes
    xfce.xfce4_whiskermenu_plugin
    xfce.xfce4_systemload_plugin
    xfce.xfce4_pulseaudio_plugin
    numix-gtk-theme numix-icon-theme
  ];
}
