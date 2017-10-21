{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkgconfig python ruby
    # utilities
    wget unzip rsync emacs
    # nix
    nix-repl nixops nix-prefetch-git
    # desktop
    firefox
    networkmanagerapplet
    xscreensaver
    spotify
    yakuake konsole
    gnome3.gconf
    evince
    hexchat
    nixops qemu
  ];

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };
  };

  virtualisation.libvirtd = {
    enable = true;
  };

  networking.firewall.checkReversePath = false;

  services = {
    keybase.enable = true;

    kbfs = {
      enable = true;
      mountPoint = "/keybase";
    };

    arbtt.enable = true;

    printing.enable = true;
  };

  programs = {
    # want to remember keys on here
    ssh.startAgent = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      dejavu_fonts
      iosevka
    ];
  };
}
