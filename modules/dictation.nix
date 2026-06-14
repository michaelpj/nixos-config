# Voice dictation (speech-to-text) via Vocalinux.
#
# Vocalinux types recognised speech into the focused application. On a Wayland
# session there is no global synthetic-input API, so it drives the `ydotool`
# daemon (which writes to /dev/uinput). `programs.ydotool.enable` installs the
# tool, runs the per-user `ydotoold` service and adds the udev rule that grants
# the logged-in user access to /dev/uinput — without it dictation silently
# types nothing on KDE Plasma Wayland.
{ config, pkgs, ... }:

{
  programs.ydotool.enable = true;

  home-manager.users.michael.home.packages = [ pkgs.vocalinux ];
}
