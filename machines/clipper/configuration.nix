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
      ../../modules/security.nix

      ../../modules/work/iohk/binary-cache.nix
      ../../modules/cachix.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      # Reload the module-bluetooth-policy module with auto_switch=2,
      # which makes it switch to the headset policy when an audio input
      # stream appears.
      extraConfig = ''
        unload-module module-bluetooth-policy
        load-module module-bluetooth-policy auto_switch=2
        load-module module-switch-on-connect
      '';
    };
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
      # Get scrolling when holding down the fn button on the elecom mouse
      # It would be nice if I could scope this per-device?
      scrollButton = 11;
      scrollMethod = "button";
    };
    fwupd.enable = true;

    # override nixos-hardware profile
    throttled.enable = false;
  
    thermald = {
      enable = true;
      configFile = ./thermald/thermal-conf.xml.auto;
    };
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };
  
  system.stateVersion = "20.03";

  # TODO: move to nixos-hardware

  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';
}
