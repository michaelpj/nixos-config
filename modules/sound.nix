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
  };

  environment.systemPackages = with pkgs; [
    pulseaudioFull # needed to provide additional tools (pipewire can be configured via pulseaudio commands) and needed by zoom to provide advanced share screen options (optimized for video…)
  ];
}
