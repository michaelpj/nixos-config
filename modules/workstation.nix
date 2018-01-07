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
    yakuake konsole
    evince okular
    konversation
    nixops qemu
  ];

  virtualisation = {
    #virtualbox.host.enable = true;
    libvirtd.enable = true;
  };

  networking.firewall.checkReversePath = false;

  services = {
    keybase.enable = true;

    kbfs = {
      enable = true;
      mountPoint = "/keybase";
    };

    #arbtt.enable = true;

    printing.enable = true;
  };

  programs = {
    # want to remember keys on here
    ssh.startAgent = true;
  };
}
