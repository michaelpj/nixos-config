autoload -U colors && colors

# Makes completion slow, see https://github.com/sorin-ionescu/prezto/issues/1876
unsetopt PATH_DIRS

set -o vi

setopt CLOBBER

# Report time for commands longer than 20s
REPORTTIME=20

# Aliases

alias tmux='tmux -2'
alias em='emacsclient -nw --alternate-editor=""'
alias emw='emacsclient --alternate-editor=""'

# fuzzy select pid
alias pid="ps axww -o pid,user,%cpu,%mem,start,time,command | fzf --reverse --height=20% | sed 's/^ *//' | cut -f1 -d' '"

# nix aliases
alias ns='nix-shell'
alias nb='nix build -f default.nix -L'
alias nixpkgs='nix-build --no-out-link "<nixpkgs>" -A'
NIXBUILD_BUILDERS="ssh://eu.nixbuild.net x86_64-linux - 100 1 big-parallel,benchmark"
ZWRK_BUILDERS="ssh://x86_64-linux-1.zw3rk.com x86_64-linux - 10 1 big-parallel,benchmark"
alias nbr='nix build -f default.nix -L --builders "$REMOTE_BUILDERS"'

alias vf="vim \$(ls | fzf --reverse --height=20%)"

EDITOR=vim
VISUAL=gvim

eval "$(zoxide init zsh)"
eval "$(h --setup ~/code)"
