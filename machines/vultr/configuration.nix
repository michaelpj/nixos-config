{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };

  networking.hostName = "vps";

  system.stateVersion = "20.03";
}
