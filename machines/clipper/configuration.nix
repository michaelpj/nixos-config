{ config, pkgs, nixos-hardware, home-manager, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      home-manager.nixosModules.home-manager
      ../../modules/home-manager.nix

      ../../modules/basics.nix
      ../../modules/laptop.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    bluetooth.enable = true;
    graphics.enable32Bit = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # I don't really care about these issues on my laptop
    kernelParams = [ "mitigations=off" ];
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;

    # override nixos-hardware profile
    throttled.enable = false;
    thermald.enable = true;
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };

  virtualisation.docker.enable = true;
  
  system.stateVersion = "20.03";

  # TODO: move to nixos-hardware

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

}
