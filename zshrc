# export DISABLE_AUTO_UPDATE=true
export DISABLE_AUTO_TITLE=true
export SRC="$HOME/src"
export DOTFILES="$HOME/dotfiles"
export EDITOR=vim
export GIT_EDITOR="$EDITOR"
export PROMPT_COMMAND="history -a; history -n"

# This supposedly fixes vim the "tags file not sorted" error in vim.  So far, it
# seems to have done the trick.
export LC_COLLATE=C

source "$HOME/.env"

autoload -U promptinit && promptinit
setopt PROMPT_SUBST

autoload -U compinit
compinit

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt auto_cd
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# system stuffs {{{1
alias r="source $HOME/.zshrc"
alias p="$EDITOR ~/dotfiles/zshrc"
alias mkdir="mkdir -p"

alias s="cd $HOME/src"


d   () { mkdir -p "$@" && cd "$@"; }
g   () { mkdir -p "$@" && cd "$@" && git init; }

bcd () { cd $(bundle show $@) }

__compl_srccd ()
{
  compctl -k ($(ls -F $SRC/$1/ | grep -v "/$" | tr "\n/" " ")) $2
}
vcd () { cd "$SRC/vim/$@" }
gcd () { cd "$SRC/gems/$@" }
scd ()
{
  if (( $# == 0 )); then
    cd $SRC
  else
    cd "$SRC/$@"
  fi

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

export MYSQL_PS1="\d> "

# projects {{{1
alias nuvango="cd $SRC/nuvango/retail && clear"
alias dotfiles="cd ~/dotfiles"
alias songs="$EDITOR ~/docs/band/songs.md"

# tmux
ide() { "$DOTFILES/ide.sh" }

# stuff
alias rs="bundle exec foreman start -f Procfile.dev"

# git {{{1
alias gs="git status -s"
alias gb="git branch"
alias gc="git commit"
alias gC="git commit --amend --no-edit"
alias grim="git rebase -i master"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gM="git checkout master"
alias gf="git fetch"
alias gfm="git fetch master"
alias gl="git log --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias l="gL master.."
# alias gl="git log --graph --pretty=format:'%Cred%h%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit"
# alias gL="git log --graph --pretty=format:'%C(red)%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="git diff"
alias gD="git diff --name-only"
alias gdm="git diff master"
alias gdM="git diff master --name-only"
alias gr="git reset"
alias gS="git reset --soft HEAD\^"
alias gR="git reset --hard"
alias ga="git add"
alias gap="git add -p"

L ()
{
  local out shas sha q k
  while out=$(
      l "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --print-query --expect=ctrl-d --toggle-sort=\` \
    ); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

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
    echo $(jobs | grep -v "pwd now:" | awk 'BEGIN {FS="[-+ ]+"; ORS=""; print "\("} {print "%{%F{108}%}"$3"%{%F{238}%},"} END {print "\)"}' | sed 's/,)$/)/g')
  else
    echo ""
  fi
}

battery()
{
  ~/dotfiles/sh/battery.sh
}


# Prompt {{{1

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

alias carbon='python /opt/graphite/bin/carbon-cache.py'
alias graphite-web='python /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite'

# tmux
alias ta="tmux attach-session -t "

# tasks {{{1
alias -g ctags="/usr/local/bin/ctags -R -f tags --exclude=.git --exclude=log --exclude=public --exclude=tmp --exclude=app/assets --exclude=vendor"

# And so on {{{1
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
# bindkey -M viins 'jk' vi-cmd-mode

# t {{{1
alias t='python ~/src/apps/t/t.py --task-dir ~/tasks --list tasks'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && source $(brew --prefix)/etc/profile.d/autojump.sh

# zfz {{{1
export FZF_TMUX=1
# export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD | grep -v fonts\/ | grep -v images\/ || find * -name ".*" -prune -o -type f -print -o -type l -print) 2> /dev/null'
export FZF_DEFAULT_COMMAND='ag -g ""'

export NVM_DIR="/Users/andrwe/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
