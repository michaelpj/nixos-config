{ config, pkgs, nixos-hardware, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.framework-13-7040-amd
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    bluetooth.enable = true;
    graphics.enable32Bit = true;
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
      "amdgpu.sg_display=0"
    ];
    # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/77
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="GB"
    '';
  };

  services = {
    fprintd = {
      enable = true;
    };
    fstrim.enable = true;
    fwupd.enable = true;
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  virtualisation.docker.enable = true;

  networking = {
    hostName = "schooner";
    hostId = "0aaddb32";
  };

  system.stateVersion = "23.05";

}
