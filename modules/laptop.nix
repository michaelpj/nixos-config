{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs.powertop
    pkgs.acpi
    pkgs.upower
  ];

  services.upower.enable = true;
}
