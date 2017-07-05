{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../config/nix.nix
      ../../config/nixpkgs.nix
      ../../config/networking.nix
      ../../config/basics.nix
      ../../config/locales.nix
      ../../config/development-machine.nix
      ../../config/desktop-manager.nix
      ../../config/laptop.nix
      ../../config/accounts.nix
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
