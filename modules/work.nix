{ pkgs, llm-agents-nix, ... }:
let
  llmAgents = llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with pkgs; [
    # build-essentials
    binutils
    gcc
    gnumake
    pkg-config
    ruby
    # utilities
    wget
    zip
    unzip
    rsync

    fd
    ripgrep

    zoxide

    graphviz
    jq
    plantuml
    tmuxinator
    # text
    vscode
    editorconfig-core-c
    pandoc
    aspell
    # system
    iotop
    s-tui
    procs
    pstree
    parted
    gparted
    pgcli
    lsof
    ncdu
    strace
    unetbootin
    usbutils
    pciutils
    # vc
    gh
    tig
    diff-so-fancy
    jujutsu
    lazyjj
    # dev
    mergiraf
    haskellPackages.ghc
    haskellPackages.haskell-language-server
    cabal-install
    via
    haskellPackages.ghc-prof-flamegraph
    hlint
    stylish-haskell
    python3
    flamegraph
    qemu
    go-jira
    # nix
    nix-prefetch-git
    cachix
    niv
    nix-diff
    nix-du #nixops
    # comms
    element-desktop
    slack
    discord
    signal-desktop
    # audio
    pavucontrol
    alsa-utils
    # desktop
    google-chrome
    kdePackages.yakuake
    kdePackages.konsole
    evince
    kdePackages.okular
    libreoffice
    gimp
    vault
    llmAgents.claude-code
    llmAgents.codex
    llmAgents.coderabbit-cli
    llmAgents.hunk
    remmina
    donethat
  ];

  # Symlink Hunk's bundled review skill into Claude Code's skills directory.
  # Pointing at the package output (rather than a fixed store path) keeps it in
  # sync whenever hunk is upgraded. Skill path comes from `hunk skill path`.
  home.file.".claude/skills/hunk-review/SKILL.md".source =
    "${llmAgents.hunk}/skills/hunk-review/SKILL.md";

  programs.firefox = {
    enable = true;
  };

}
