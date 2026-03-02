{ config, pkgs, ... }:
{
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;

    wireplumber.extraConfig = {
      "50-bluetooth" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-msbc" = true;   # wideband speech codec for HFP (better quality + stability)
          "bluez5.enable-sbc-xq" = true; # high-quality SBC variant for A2DP
          "bluez5.enable-hw-volume" = true;  # let headphones handle volume natively
        };
        "monitor.bluez.rules" = [
          {
            # Increase Bluetooth audio headroom to absorb brief transport hiccups
            matches = [{ "device.name" = "~bluez_card.*"; }];
            actions = {
              update-props = {
                "api.bluez5.internal" = false;
                "bluez5.auto-connect" = "[ hfp_hf hsp_hs a2dp_sink ]";
              };
            };
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pulseaudioFull # needed to provide additional tools (pipewire can be configured via pulseaudio commands) and needed by zoom to provide advanced share screen options (optimized for video…)
  ];
}
