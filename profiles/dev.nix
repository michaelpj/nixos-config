{ config, pkgs, nixos-hardware, home-manager, lib, ... }:
{

  imports = [
      ../modules/nix.nix
      ../modules/nixpkgs.nix
      ../modules/networking.nix
      ../modules/basics.nix
      ../modules/locales.nix
      ../modules/workstation.nix
      ../modules/graphical.nix
      ../modules/sound.nix
      ../modules/users.nix
      ../modules/security.nix

      ../modules/work/iohk/binary-cache.nix
      ../modules/cachix.nix
      ../modules/nixbuild.nix
      ../modules/zwrk.nix
  ];
}
