{ config, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      (import ../overlays/fixes.nix)
      (import ../overlays/configs.nix)
    ];
  };
}
