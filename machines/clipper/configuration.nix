{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      <nixos-hardware/lenovo/thinkpad/t480s>

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
      ../../modules/research.nix

      ../../modules/work/iohk/binary-cache.nix
      ../../modules/cachix.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
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
    xserver.libinput = {
      enable = true;
      disableWhileTyping = true;
    };
    fwupd.enable = true;
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };
  
  system.stateVersion = "18.09";

  # TODO: move to nixos-hardware

  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';
}
