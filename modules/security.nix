{ config, pkgs, ... }:

{
  hardware.u2f.enable = true;

  services.pcscd.enable = true;

  # yubikey stuff
  environment.systemPackages = [
    pkgs.yubikey-personalization
    pkgs.yubikey-personalization-gui
    pkgs.yubikey-manager
    pkgs.yubikey-manager-qt
    pkgs.yubioath-desktop
  ];
}
