{ config, pkgs, ... }:

{
  nixpkgs = {
    config = import ../nixpkgs/config.nix;
    overlays = import ../nixpkgs/overlays.nix;
  };
}
