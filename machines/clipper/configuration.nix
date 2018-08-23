{ config, pkgs, ... }:


let
  nixos-hardware = (import ../../nix-misc/external-sources).nixos-hardware;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      "${nixos-hardware}/lenovo/thinkpad/t480s"

      ../../modules/nix.nix
      ../../modules/nixpkgs.nix
      ../../modules/networking.nix
      ../../modules/basics.nix
      ../../modules/locales.nix
      ../../modules/workstation.nix
      ../../modules/graphical.nix
      ../../modules/laptop.nix
      ../../modules/users.nix
      ../../modules/entertainment.nix
      ../../modules/research.nix
      ../../modules/semmle-vpn.nix
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    opengl.driSupport32Bit = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  services = {
    thermald.enable = true;
    fstrim.enable = true;
    xserver.libinput = {
      enable = true;
      disableWhileTyping = true;
    };
    fwupd.enable = true;
    fprintd.enable = true;
  };

  # zfs
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoScrub.enable = true;

  networking = {
    hostName = "clipper"; 
    hostId = "635f8603";
  };
  
  system.stateVersion = "18.09";

  # TODO: move to nixos-hardware

  services.tlp.extraConfig = ''
    START_CHARGE_THRESH_BAT0=75
    STOP_CHARGE_THRESH_BAT0=80
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
    ENERGY_PERF_POLICY_ON_BAT=powersave
  '';

  systemd.services.cpu-throttling = {
    enable = true;
    description = "Sets the offset to 3 °C, so the new trip point is 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "Set cpu heating limit to 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
};
}
