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
      ];
    };
    gh.enable = true;
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
      initExtra = builtins.readFile ../dotfiles/.zshrc + builtins.readFile ../dotfiles/.p10k.zsh;
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      # one day
      maxCacheTtl = 86400;
      # six hours
      defaultCacheTtl = 21600;
    };
  };
}
