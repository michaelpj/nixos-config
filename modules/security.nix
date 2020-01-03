{ config, pkgs, ... }:

{
  # enable u2f
  hardware.u2f.enable = true;

  # enable smart card reader driver
  services.pcscd.enable = true;

  # yubikey stuff
  services.udev.packages = [ pkgs.yubikey-personalization ];
  environment.systemPackages = [
    pkgs.yubikey-personalization
    pkgs.yubikey-personalization-gui
    pkgs.yubikey-manager
    pkgs.yubikey-manager-qt
    pkgs.yubioath-desktop
  ];
}
