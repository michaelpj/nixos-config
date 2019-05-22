{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    spotify 
    vlc
  ];
}
