{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../conf/nix.nix
      ../../conf/nixpkgs.nix
      ../../conf/networking.nix
      ../../conf/basics.nix
      ../../conf/locales.nix
      ../../conf/development-machine.nix
      ../../conf/desktop-manager.nix
      ../../conf/accounts.nix
    ];

  hardware.trackpoint.emulateWheel = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "mini"; 
    hostId = "05af16a2";
  };

  time.timeZone = "Europe/London";
}
