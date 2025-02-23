{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # build-essentials
    binutils gcc gnumake pkg-config ruby
    # utilities
    wget zip unzip rsync  

    fd ripgrep 

    zoxide h

    graphviz
    jq
    plantuml
    tmuxinator
    # text
    # emacs 
    vscode
    editorconfig-core-c
    pandoc
    aspell 
    # system
    iotop s-tui
    procs pstree
    parted gparted
    pgcli
    lsof ncdu
    strace
    unetbootin
    usbutils pciutils
    # vc
    gh tig
    gitAndTools.diff-so-fancy
    jujutsu
    # https://github.com/NixOS/nixpkgs/issues/370890
    #lazyjj
    # dev
    haskellPackages.ghc haskellPackages.haskell-language-server
    cabal-install haskellPackages.ghc-prof-flamegraph hlint stylish-haskell 
    python3
    flamegraph
    qemu
    go-jira
    # nix
    nix-prefetch-git cachix niv nix-diff nix-du #nixops
    # comms
    element-desktop slack zoom-us discord signal-desktop
    zulip
    # audio
    pavucontrol alsa-utils
    # desktop
    google-chrome
    yakuake konsole
    evince okular
    libreoffice
    gimp
    logseq
    vault
  ];

  programs.firefox = {
    enable = true;
  };

}
