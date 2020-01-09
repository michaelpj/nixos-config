{ config, pkgs, ... }:

{
  imports = [ ./direnv.nix ];

  environment.systemPackages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkgconfig python ruby
    # utilities
    wget unzip rsync emacs editorconfig-core-c gitAndTools.diff-so-fancy
    # nix
    nix-prefetch-git
    # desktop
    firefox
    yakuake konsole
    evince okular
    konversation
    qemu
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
    # just can't make it work well, usually issues with env vars
    #emacs.enable = true;
  };

  programs = {
    # want to remember keys on here
    ssh.startAgent = true;
    gnupg.agent.enable = true;
  };
}
