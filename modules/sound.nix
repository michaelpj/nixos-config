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
          # mSBC disabled: on the MT7922 the transparent-eSCO path it needs is
          # flaky and caused mid-call SCO transport death (firmware/host handle
          # desync). CVSD is narrowband but robust.
          "bluez5.enable-msbc" = false;
          "bluez5.enable-sbc-xq" = true; # high-quality SBC variant for A2DP
          "bluez5.enable-hw-volume" = true;  # let headphones handle volume natively
        };
        "monitor.bluez.rules" = [
          {
            matches = [{ "device.name" = "~bluez_card.*"; }];
            actions = {
              update-props = {
                "api.bluez5.internal" = false;
                "bluez5.auto-connect" = "[ hfp_hf hsp_hs a2dp_sink ]";
              };
            };
          }
          {
            # Keep BT transport alive — prevents PipeWire from releasing and
            # reacquiring the transport during brief idle moments, which is
            # fragile and causes HFP reconnection storms on the MT7922.
            matches = [{ "node.name" = "~bluez_*.*"; }];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };
}
