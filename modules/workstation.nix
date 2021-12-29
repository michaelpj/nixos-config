{ config, pkgs, ... }:

{
  imports = [ ./direnv.nix ];

  environment.systemPackages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkgconfig python ruby
    # utilities
    wget zip unzip rsync  
    fd ripgrep heatseeker
    graphviz
    gnupg
    jq
    plantuml
    # text
    emacs vscode
    editorconfig-core-c
    pandoc
    aspell 
    # system
    iotop s-tui
    procs pstree
    parted gparted
    lsof ncdu
    strace
    unetbootin
    usbutils pciutils
    # vc
    gh tig
    gitAndTools.diff-so-fancy
    # dev
    cabal-install ghc haskellPackages.ghc-prof-flamegraph hlint stylish-haskell
    python3
    flamegraph
    qemu
    go-jira
    # nix
    nix-prefetch-git cachix niv nix-diff nix-du nix-top #nixops
    # comms
    element-desktop slack zoom-us discord signal-desktop
    skypeforlinux
    # audio
    pavucontrol alsa-utils
    # desktop
    firefox google-chrome
    yakuake konsole
    evince okular
    libreoffice
    gimp
  ];

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  boot.tmpOnTmpfs = true;

  networking.firewall.checkReversePath = false;

  services = {
    printing.enable = true;
  };

  programs = {
    # want to remember keys on here
    ssh.startAgent = true;
    gnupg.agent.enable = true;
    hamster.enable = true;
  };
}
