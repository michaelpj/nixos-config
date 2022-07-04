{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.users.michael = import ./home.nix;
}
