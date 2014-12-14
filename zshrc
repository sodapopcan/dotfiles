export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="andrwedisagrees"
export DISABLE_AUTO_UPDATE=true
export DISABLE_AUTO_TITLE=true
export SRC="$HOME/src"
export EDITOR=vim

source $HOME/.env

autoload -U promptinit && promptinit
setopt PROMPT_SUBST

# system stuffs {{{1
alias l="ls -lh"
alias la="ls -lah"
alias ..="cd .. && ls -l"
alias ...="cd ../.. && ls -l"
alias ....="cd ../../.. && ls -la"
alias r="source $HOME/.zshrc"
alias p="$EDITOR ~/dotfiles/zshrc"
alias mkdir="mkdir -p"
alias j="autojump"

alias s="cd $HOME/src"

mcd () { mkdir -p "$@" && cd "$@"; }

gcd() { cd $(bundle show $@) }

colours() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}


# theme {{{1
export CLICOLOR=1
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:$HOME/vert.x-2.1.2/bin"


# projects {{{1
alias gelaskins="cd $SRC/work/spree_gelaskins && clear"
alias dotfiles="cd ~/dotfiles"
alias songs="$EDITOR ~/docs/band/songs.md"

# tmux
ide() { $HOME/dotfiles/ide.sh }

# git {{{1
alias gs="clear && git status"
alias gb="clear && git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gc="git commit"
alias gC="git commit --amend --no-edit"
alias gco="git checkout"
alias gcom="git checkout master"
alias gcob="git checkout -b"
alias gl="git log"
alias gd="git diff"
alias gdf="git diff --name-only"
alias gdm="git diff master"
alias gus="git submodule foreach git pull origin master"
alias gr="git reset"
alias gS="git reset --soft"
alias gR="git reset --hard"
alias ga="git add"
alias gap="git add -p"

gitprune() {
  git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" \
    --prune-empty --tag-name-filter cat -- --all
}

# If it's a git repository, show only the name of the containing directory
current_project() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [ -z $ref ]; then
    echo "${PWD/#$HOME/~}"
  else
    echo "$(basename $(git rev-parse --show-toplevel))"
  fi
}

# If in a subdirectory of a git repository, show the sub-path in a different colour
current_relative_path() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  project_dir=$(git rev-parse --show-toplevel)
  rel_path=${${PWD}/${project_dir}}
  if [ -n ${rel_path} ]; then
    echo "$rel_path"
  fi
}

current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo $(git branch | grep \* | sed 's/^..//')
}

PS1='
  %B%{%F{black}%}$(current_project) %b%{%F{red}%}$(current_branch)%{%F{black}%} $(current_relative_path)
%(?.%{%F{black}%}.%{%F{red}%})$%{%F{black}%} '


# vim / editor {{{1
e()
{
  if [ $# -gt 0 ]; then
    $EDITOR -O $@
  elif [ -f "Session.vim" ]; then
    $EDITOR -S Session.vim
  else
    $EDITOR
  fi
}

E()
{
  if [ $# -gt 0 ]; then
    $EDITOR -O $@
  else
    $EDITOR
  fi
}


alias vid='e $(git diff master --name-only)'

alias t='python ~/src/projects/t/t.py --task-dir ~/tasks --list tasks'
alias carbon='python /opt/graphite/bin/carbon-cache.py'
alias graphite-web='python /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite'

# tmux
alias ta="tmux attach-session -t "

# tasks {{{1
alias -g ctags="ctags -R -f tags --exclude=.git --exclude=log --exclude=public --exclude=tmp --exclude=app/assets --exclude=vendor"

# And so on {{{1
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey -M viins 'jk' vi-cmd-mode
