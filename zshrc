# export DISABLE_AUTO_UPDATE=true
export DISABLE_AUTO_TITLE=true
export SRC="$HOME/src"
export EDITOR=vim
export PROMPT_COMMAND="history -a; history -n"
export LC_COLLATE=C

source $HOME/.env

autoload -U promptinit && promptinit
setopt PROMPT_SUBST

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# system stuffs {{{1
alias l="ls -lh"
alias L="ls -lht"
alias .="ls -lah"
alias la="ls -laht"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias r="source $HOME/.zshrc"
alias p="$EDITOR ~/dotfiles/zshrc"
alias mkdir="mkdir -p"

alias s="cd $HOME/src"

dir ()
{
  mkdir -p "$@" && cd "$@";
}

g ()
{
  mkdir -p "$@" && cd "$@" && git init;
}

gcd()
{
  cd $(bundle show $@)
}

colours()
{
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}


# theme {{{1
export CLICOLOR=1
export PATH="/usr/local/bin:$PATH"
export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:$HOME/vert.x-2.1.2/bin"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export MYSQL_PS1="\d> "

# projects {{{1
alias nuvango="cd $SRC/nuvango/retail && clear"
alias dotfiles="cd ~/dotfiles"
alias songs="$EDITOR ~/docs/band/songs.md"

# tmux
ide() { $HOME/ide.sh }

# git {{{1
alias gs="git status"
alias gb="git branch"
alias gc="git commit"
alias gC="git commit --amend --no-edit"
alias gco="git checkout"
alias gM="git checkout master"
alias gl="git log"
alias gd="git diff"
alias gD="git diff --name-only"
alias gdm="git diff master"
alias gdM="git diff master --name-only"
alias gus="git submodule foreach git pull origin master" # Leaving this for posterity
alias gr="git reset"
alias gS="git reset --soft HEAD\^"
alias gR="git reset --hard"
alias ga="git add"
alias gA="git add -p"

gitprune()
{
  git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" \
    --prune-empty --tag-name-filter cat -- --all
}

is_git_repo()
{
  git symbolic-ref HEAD 2> /dev/null
}

# If it's a git repository, show only the name of the containing directory
current_project()
{
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [ -z $ref ]; then
    echo "${PWD/#$HOME/~}"
  else
    echo "$(basename $(git rev-parse --show-toplevel))"
  fi
}

# If in a subdirectory of a git repository, show the sub-path in a different colour
current_relative_path()
{
  ref=$(is_git_repo) || return
  project_dir=$(git rev-parse --show-toplevel)
  rel_path=${${PWD}/${project_dir}}
  if [ -n ${rel_path} ]; then
    echo "$rel_path"
  fi
}

current_branch()
{
  ref=$(is_git_repo) || return
  echo " $(git branch | grep \* | sed 's/^..//') "
}

dirty_tree()
{
  if [ -z $(is_git_repo) ]; then
    echo ""
  else
    if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
      echo '%{%F{red}%}✗%{%F{black}%}'
    else
      echo '%{%F{green}%}✔%{%F{black}%}'
    fi
  fi
}

# Jobs

job_prompt_string()
{
  if [[ $(jobs 2> /dev/null) != "" ]]; then
    echo $(jobs | awk 'BEGIN {FS="[-+ ]+"; ORS=""; print "("} {print "%{%F{192}%}"$3"%{%F{238}%},"} END {print ")"}' | sed 's/,)$/)/g')
  else
    echo ""
  fi
}

battery()
{
  ~/dotfiles/sh/battery.sh
}


# Prompt {{{1

# ㋡
# ◔̯◔
PS1='
   %{%F{253}%}$(current_project)%{%F{241}%}$(current_relative_path) $(dirty_tree)%{%F{248}%}$(current_branch)%{%F{238}%}$(job_prompt_string)
%(?.%{%F{108}%} *.%{%F{167}%} *)%{%F{232}%}%b '


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
alias -g ctags="/usr/local/bin/ctags -R -f tags --exclude=.git --exclude=log --exclude=public --exclude=tmp --exclude=app/assets --exclude=vendor"

# And so on {{{1
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey -M viins 'jk' vi-cmd-mode
