{ config, pkgs, ... }:

{
  # enable smart card reader driver
  services.pcscd.enable = true;

  # yubikey stuff
  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.systemPackages = [
    pkgs.yubikey-personalization
    pkgs.yubikey-manager
  ];
}
