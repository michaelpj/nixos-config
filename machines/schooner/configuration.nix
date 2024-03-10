{ config, pkgs, nixos-hardware, home-manager, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.framework-13-7040-amd

      home-manager.nixosModules.home-manager
      ../../modules/home-manager.nix

      ../../modules/basics.nix
      ../../modules/laptop.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    bluetooth.enable = true;
    #pulseaudio = {
      #enable = true;
      #support32Bit = true;
      #package = pkgs.pulseaudioFull;
      # Reload the module-bluetooth-policy module with auto_switch=2,
      # which makes it switch to the headset policy when an audio input
      # stream appears.
      #extraConfig = ''
        #unload-module module-bluetooth-policy
    
        #load-module module-bluetooth-policy auto_switch=2
        #load-module module-switch-on-connect
      #'';
    #};
    opengl.driSupport32Bit = true;
    enableRedistributableFirmware = true;
    # this is on by default but let's make sure so we can set it
    wirelessRegulatoryDatabase = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelParams = [ 
      # I don't really care about these issues on my laptop
      "mitigations=off" 
    ];
    # See if this helps stuff
    kernelPackages = pkgs.linuxPackages_6_7;
    # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/77
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="GB"
    '';
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
