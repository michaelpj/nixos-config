{ config, pkgs, home-manager, ... }:
{
  imports = [
    ./base.nix

    home-manager.nixosModules.home-manager
    ../modules/home-manager.nix

    ../modules/networking.nix
    ../modules/workstation.nix
    ../modules/graphical.nix
    ../modules/sound.nix
    ../modules/security.nix
    ../modules/dictation.nix

    ../modules/1password.nix
    ../modules/bitwarden.nix
    ../modules/cachix.nix
    ../modules/nixbuild.nix
  ];
}
