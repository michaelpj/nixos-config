{ config, pkgs, nixos-hardware, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      nixos-hardware.nixosModules.framework-13-7040-amd
    ];

  hardware = {
    trackpoint.emulateWheel = true;
    # Stabilise HFP (hands-free) profile — the MediaTek MT7921 adapter
    # drops the HFP transport every few minutes under default settings.
    bluetooth = {
      enable = true;
      settings = {
        General = {
          FastConnectable = true;                  # stay connectable so reconnects are fast
          ReconnectAttempts = 7;                    # retry on disconnect (default 0)
          ReconnectIntervals = "1,2,4,8,16,32,64"; # exponential backoff (seconds)
          Experimental = true;                     # better codec negotiation + battery reporting
        };
        Policy = {
          AutoEnable = true;                       # auto-enable adapter on boot
        };
      };
    };
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
      # Flicker-free boot: silence the console so it doesn't stomp the
      # Plymouth splash. See consoleLogLevel/initrd.verbose below.
      "quiet"
      "udev.log_level=3"
    ];

    # Quiet boot for a clean Plymouth splash. Hit Esc during boot to drop
    # the splash and see console output if something hangs.
    consoleLogLevel = 0;
    initrd.verbose = false;

    # Load the GPU driver in the initrd so KMS sets the display mode once,
    # early, and never switches — this is what makes the splash flicker-free
    # rather than flashing when amdgpu takes over from the firmware framebuffer.
    initrd.kernelModules = [ "amdgpu" ];
    # https://community.frame.work/t/framework-nixos-linux-users-self-help/31426/77
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="GB"
      # Prevent btusb from enabling USB autosuspend (causes HFP transport drops on MT7921)
      options btusb enable_autosuspend=0
    '';
  };

  # Prevent USB autosuspend on MediaTek Bluetooth adapter (MT7921)
  # to avoid HFP transport drops — set both control and autosuspend delay
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", ATTR{idProduct}=="e616", ATTR{power/control}="on", ATTR{power/autosuspend}="-1", ATTR{power/autosuspend_delay_ms}="-1"
  '';

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
