{ config, pkgs, ... }:


let
  nixos-hardware = (import ../../nix-misc/external-sources).nixos-hardware;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # none of the profiles quite fit, but these apply
      "${nixos-hardware}/lenovo/thinkpad"
      "${nixos-hardware}/common/cpu/intel"
      "${nixos-hardware}/common/pc/ssd"

      ../../modules/nix.nix
      ../../modules/nixpkgs.nix
      ../../modules/networking.nix
      ../../modules/basics.nix
      ../../modules/locales.nix
      ../../modules/workstation.nix
      ../../modules/graphical.nix
      ../../modules/laptop.nix
      ../../modules/users.nix
      ../../modules/entertainment.nix
      ../../modules/semmle-vpn.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
  };

  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # thinkpad stuff
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
  boot.kernelModules = [ "acpi_call" ];

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  services.fprintd.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };
}
