{ pkgs, ... }:

{
  imports = [
    ./entertainment.nix
    ./research.nix
    ./work.nix
  ];

  fonts.fontconfig.enable = true;

  xdg.enable = true;

  home = {
    packages = with pkgs; [
      gnupg

      # dictionaries
      aspell
      aspellDicts.en
      aspellDicts.uk
    ];
    stateVersion = "22.05";
  };

  #nix = {
  #package = pkgs.nixUnstable;
  #settings = {
  #experimental-features = "nix-command flakes";
  #allow-import-from-derivation = true;
  #};
  #};

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    emacs.enable = true;
    bash = {
      enable = true;
      initExtra = builtins.readFile ../dotfiles/.bashrc;
    };
    tmux = {
      enable = true;
      keyMode = "vi";
      extraConfig = builtins.readFile ../dotfiles/.tmux.conf;
    };
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      includes = [
        { path = ../dotfiles/gitconfig; }
        { condition = "gitdir:iohk/"; path = ../dotfiles/gitconfig-iohk; }
        { condition = "gitdir:input-output-hk/"; path = ../dotfiles/gitconfig-iohk; }
        { condition = "gitdir:IntersectMBO/"; path = ../dotfiles/gitconfig-iohk; }
        { condition = "gitdir:cardano-foundation/"; path = ../dotfiles/gitconfig-iohk; }
        { condition = "gitdir:circuithub/"; path = ../dotfiles/gitconfig-circuithub; }
      ];
    };
    gh = {
      enable = true;
      settings = {
        aliases = {
					jjpc = "gh pr create --head $(jj bookmark list -r @ -T name) --base $(jj bookmark list -r 'heads(::@- & bookmarks())' -T name) --fill \$@";
        };
      };
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Michael Peyton Jones";
          email = "me@michaelpj.com";
        };
        ui = {
          editor = "vim";
          default-command = "status";
          pager = "delta";
          diff.format = "git";
        };
        signing = {
          behaviour = "own";
          backend = "gpg";
          key = "86A43C24A728F66D";
        };
      };
    };
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        airline
        fugitive
        vim-markdown
        nerdtree
        nerdcommenter
        molokai
        repeat
        surround
        syntastic
      ];
      extraConfig = builtins.readFile ../dotfiles/.vimrc;
    };
    zsh = {
      enable = true;
      prezto = {
        enable = true;
        # https://github.com/nix-community/home-manager/issues/2255
        caseSensitive = true;
        prompt.theme = "powerlevel10k";
        pmodules = [
          "environment"
          "terminal"
          "editor"
          "history"
          "directory"
          "spectrum"
          "utility"
          "git"
          "completion"
          "syntax-highlighting"
          "history-substring-search"
          "prompt"
        ];
        editor.keymap = "vi";
      };
      initContent = builtins.readFile ../dotfiles/.zshrc + builtins.readFile ../dotfiles/.p10k.zsh;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      # one day
      maxCacheTtl = 86400;
      # six hours
      defaultCacheTtl = 21600;
      pinentry.package = pkgs.pinentry-qt;
    };
  };

  xdg.configFile."direnv/lib/oprc.sh" =
    let
      direnv-op = pkgs.fetchFromGitHub {
        owner = "venkytv";
        repo = "direnv-op";
        rev = "db976ce107a2f58fb7465a7d2f0858a37b32e1f1";
        sha256 = "sha256-2lejN0oDbssTO1Cz6zneiYIA9Gbj4r2KE1bfmzfF3F4=";
      };
    in
    {
      source = "${direnv-op}/oprc.sh";
    };
}
