{ config, pkgs, ... }:
{
  imports = [
    ./desktop.nix
    ../modules/laptop.nix
  ];
}
