{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
    acpi
    upower
  ];

  services.upower.enable = true;

  # Don't force-import the ZFS pool: a forced import can replay a stale or
  # half-written log and risks data loss. This becomes the default in 26.11.
  boot.zfs.forceImportRoot = false;
}
