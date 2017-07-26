{ config, pkgs, ... }:

{
  nixpkgs = {
    config = import ../pkgs/nixpkgs-config.nix;
    overlays = [
      (import ../overlays/fixes.nix)
      (import ../overlays/configs.nix)
    ];
  };
}
