{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/basics.nix
      ../../modules/locales.nix
      ../../modules/users.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [ ../../keys/github-mini.pub ];

  zramSwap.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "20.03";
}
