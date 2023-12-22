{ config, pkgs, nixos-hardware, home-manager, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.framework-13-7040-amd

      home-manager.nixosModules.home-manager
      ../../modules/home-manager.nix

      ../../modules/nix.nix
      ../../modules/nixpkgs.nix
      ../../modules/networking.nix
      ../../modules/basics.nix
      ../../modules/locales.nix
      ../../modules/workstation.nix
      ../../modules/graphical.nix
      ../../modules/laptop.nix
      ../../modules/users.nix
      ../../modules/security.nix

      ../../modules/work/iohk/binary-cache.nix
      ../../modules/cachix.nix
      ../../modules/nixbuild.nix
      ../../modules/zwrk.nix
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
    xserver = { 
      #videoDrivers = [ "displaylink" "modesetting" ];
      libinput = {
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
    };
    fwupd.enable = true;
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "schooner"; 
    hostId = "635f8603";
    # oops, messed up here
    #hostId = "0aaddb32";
  };
  
  system.stateVersion = "23.05";

}