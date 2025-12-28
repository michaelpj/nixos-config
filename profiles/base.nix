{ config, pkgs, ... }:
{
  imports = [
    ../modules/nix.nix
    ../modules/nixpkgs.nix
    ../modules/basics.nix
    ../modules/locales.nix
    ../modules/users.nix
  ];
}
