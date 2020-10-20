{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    #lutris
    spotify 
    vlc
  ];
}
