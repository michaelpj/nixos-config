{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam
    steam-run
    #lutris
    spotify 
    vlc
  ];
}
