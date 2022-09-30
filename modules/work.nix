{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkg-config python ruby
    # utilities
    wget zip unzip rsync  
    fd ripgrep heatseeker
    graphviz
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
}
