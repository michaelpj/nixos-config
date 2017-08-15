{ config, pkgs, ... }:

{
  nixpkgs = {
    config = import ../pkgs/nixpkgs-config.nix;
    overlays = import ../overlays/overlays.nix;
  };
}
