autoload -U colors && colors

setopt CLOBBER

# Report time for commands longer than 20s
REPORTTIME=20

# Aliases

alias g='git'
alias tmux='tmux -2'
alias em='emacsclient -nw --alternate-editor=""'
alias emw='emacsclient --alternate-editor=""'

# fuzzy select pid
function fzf_pid() {
  zle -U $(ps axww -o user,pid,ppid,start,time,command | fzf --ansi --header-lines=1 --multi | awk '{print $2}')
}
zle -N fzf_pid
bindkey "^Fp" fzf_pid

## jj
function fzf_jj_change() {
  jj log --no-graph --no-pager --color always -T 'change_id.shortest() ++ "\t" ++ description.first_line() ++ "\n"'  \
  | column --table --separator $'\t' --output-separator $'\t' --table-columns "Change ID,Description" \
  | fzf --with-nth=2,3 -n 1,2 --delimiter $'\t' --ansi --header-lines=1 --multi --preview 'jj log --color always -r "ancestors({1})"' \
  | cut -f1 -d$'\t' \
  | sed -e 's/\ *//g'
}
function _fzf_jj_change() {
  zle -U "$(fzf_jj_change)"
}
zle -N _fzf_jj_change
bindkey "^Fj" _fzf_jj_change

## git
function fzf_git_branch() {
  git branch-by-date | fzf --tac -n 2 --ansi --multi --preview 'git log --oneline --graph --date=short --color=always {2}' | cut -f2 -d' '
}
function _fzf_git_branch() {
  zle -U $(fzf_git_branch)
}
zle -N _fzf_git_branch
bindkey "^Fg" _fzf_git_branch

# nix aliases
alias ns='nix-shell'
alias nb='nix build -f default.nix -L'
alias nixpkgs='nix-build --no-out-link "<nixpkgs>" -A'
NIXBUILD_BUILDERS="ssh://eu.nixbuild.net x86_64-linux - 100 1 big-parallel,benchmark"
CH_NIXBUILD_BUILDERS="ssh://ch-nixbuild x86_64-linux - 200 1 big-parallel - -"

EDITOR=vim
VISUAL=gvim

# -F quits if less than one screen, good for jj
LESS="-g -i -M -S -w -z-4 -r -F -X"

unlock_bw () {
  if [[ -z $BW_SESSION ]] ; then
    >&2 echo 'bw locked - unlocking into a new session'
    export BW_SESSION="$(bw unlock --raw)"
  fi
}

lock_bw () {
  unset BW_SESSION
  bw lock
}

eval "$(zoxide init zsh)"
