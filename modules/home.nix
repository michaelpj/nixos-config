{ pkgs, config, lib, ... }:

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
      package = pkgs.gitFull;
      signing.format = "openpgp";
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
					jjpc = ''!gh pr create --head "$(jj bookmark list -r "$1" -T name)" --base "$(jj bookmark list -r "pr_base_of($1)" -T name)" --fill "''${@:2}"'';
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
          diff-formatter = ":git";
        };
        signing = {
          behaviour = "own";
          backend = "gpg";
          key = "86A43C24A728F66D";
        };
        templates = { 
          commit_trailers = ''if(!trailers.contains_key("Change-Id"), format_gerrit_change_id_trailer(self))'';
          git_push_bookmark = ''"mpj/jj/" ++ change_id.short()'';
        };
        revset-aliases = {
          "open_bookmarks()" = "bookmarks() & ~::immutable()";
          "pr_base_of(to)" = "coalesce(heads(::to- & open_bookmarks()), trunk())";
        };
        aliases = {
          gh-pr = [
            "util" "exec" "--"
            "sh" "-eu" "-c"
            ''
              to="$1"; shift

              bm_name () {
                jj log --no-graph -r "exactly($1, 1)" \
                  -T 'if(local_bookmarks.len() == 1, local_bookmarks ++ "\n")' |
                  { read -r name || { echo "no single local bookmark for: $1" >&2; exit 1; }; echo "''${name%\*}"; }
              }

              head="$(bm_name "$to")"
              base="$(bm_name "pr_base_of($to)")"

              jj git push -b "$head"
              jj git export
              gh pr create --head "$head" --base "$base" --fill "$@"
            ''
            "sh"
          ];
          git-sync = [
            "util" "exec" "--"
            "sh" "-eu" "-c"
            ''
              rev="$1"

              # Check if the rev has any local bookmarks
              has_bookmark=$(jj log --no-graph -r "$rev" -T 'if(local_bookmarks.len() > 0, "yes", "no")')

              if [ "$has_bookmark" = "yes" ]; then
                jj git push -r "$rev"
              else
                jj git push -c "$rev"
              fi
            ''
            "sh"
          ];
          gerrit-sync = [
            "util" "exec" "--"
            "sh" "-eu" "-c"
            ''
              rev="$1"

              jj git-sync "$rev"
              jj gerrit upload -r "$rev"
            ''
            "sh"
          ];
        };
      };
    };
    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        vim-fugitive
        vim-markdown
        nerdtree
        nerdcommenter
        molokai
        vim-repeat
        vim-surround
        syntastic
      ];
      extraConfig = builtins.readFile ../dotfiles/.vimrc;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      defaultKeymap = "viins";
      dotDir = config.home.homeDirectory;
      initContent = builtins.readFile ../dotfiles/.zshrc;
    };
    mullvad-vpn.enable = true;
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../dotfiles/starship.toml);
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

  # Automatic timezone updating, KDE-native. geotimezoned is a kded module
  # shipped with Plasma that uses geoclue (enabled system-side in
  # graphical.nix) to track the current location and update the system
  # timezone, with a banner notification when it changes. Its autoload flag
  # lives in the mutable kded6rc, so set it idempotently rather than
  # symlinking the file (which would stop KDE managing other modules' state).
  # Takes effect on next login, or run once now with:
  #   qdbus6 org.kde.kded6 /kded loadModule geotimezoned
  home.activation.enableGeotimezoned = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kded6rc --group Module-geotimezoned --key autoload true
  '';

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
