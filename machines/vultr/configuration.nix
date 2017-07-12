{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/users.nix
      ../../modules/basics.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  users.extraUsers.root.openssh.authorizedKeys.keyFiles = [ ../../keys/github-mini.pub ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
