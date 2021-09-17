{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      #<home-manager/nixos>
      #../../modules/home-manager.nix

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
      ../../modules/nixbuild.nix
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
      touchpad = {
        disableWhileTyping = true;
      };
      mouse = {
        # Get scrolling when holding down the fn button on the elecom mouse
        scrollButton = 11;
        scrollMethod = "button";
      };
    };
    fwupd.enable = true;

    # override nixos-hardware profile
    throttled.enable = false;
    thermald.enable = true;
  };
  # remove when we get to kernel 5.12 or they backport the fix for the cpuid issue
  systemd.services.thermald.serviceConfig.ExecStart = lib.mkForce "${pkgs.thermald}/sbin/thermald --no-daemon --dbus-enable --adaptive --ignore-cpuid-check";

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };
  
  system.stateVersion = "20.03";

  # TODO: move to nixos-hardware

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };
}
