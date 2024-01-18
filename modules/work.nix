{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkg-config ruby
    # utilities
    wget zip unzip rsync  
    fd ripgrep heatseeker
    graphviz
    jq
    plantuml
    tmuxinator
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
    haskellPackages.ghc haskellPackages.haskell-language-server
    cabal-install haskellPackages.ghc-prof-flamegraph hlint stylish-haskell 
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
    google-chrome
    yakuake konsole
    evince okular
    libreoffice
    gimp
    #biscuit-cli
  ];

  programs.firefox = {
    enable = true;
  };
}
