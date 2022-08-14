# export DISABLE_AUTO_UPDATE=true
export DISABLE_AUTO_TITLE=true
export SRC="$HOME/src"
export DOTFILES="$HOME/dotfiles"
export EDITOR=vim
export GIT_EDITOR="$EDITOR"
export PROMPT_COMMAND="history -a; history -n"
export PATH="$HOME/dotfiles/bin:$PATH"
export ERL_AFLAGS="-kernel shell_history enabled"
export PATH="$HOME/.rbenv/bin:$PATH" # rbenv
# Haskell stuff
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.stack/snapshots/x86_64-osx/lts-11.5/8.2.2/bin:$PATH"
export PATH="$HOME/.stack/compiler-tools/x86_64-osx/ghc-8.2.2/bin:$PATH"
export PATH="$HOME/.stack/programs/x86_64-osx/ghc-8.2.2/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export CPATH=/opt/homebrew/include
export LIBRARY_PATH=/opt/homebrew/lib
# Fixes problems with Erlang on Apple Chip
export CFLAGS="-O2 -g -arch arm64"
export CXXFLAGS="-arch arm64"
export LDFLAGS="-arch arm64"
# https://stackoverflow.com/questions/64185912/need-help-installing-ruby-2-7-2-on-mac
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# Disable abhorrent eslint default behaviour
export ESLINT_NO_DEV_ERRORS=true

# This supposedly fixes vim the "tags file not sorted" error in vim.  So far, it
# seems to have done the trick.
export LC_COLLATE=C

autoload -U promptinit && promptinit
setopt PROMPT_SUBST

autoload -U compinit
compinit

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

alias permit_alacritty='xattr -d com.apple.quarantine $(which alacritty)'

# system stuffs {{{1
alias r="source $HOME/.zshrc"

d () { mkdir -p "$1" && cd "$1"; }
g () { mkdir -p "$1" && cd "$1" && git init; }

bcd () { cd $(bundle show $1) }

__compl_srccd ()
{
  compctl -k ($(ls -F $SRC/$1/ | grep -v "/$" | tr "\n/" " ")) $2
}
vcd () { cd "$SRC/vim/$1" }
gcd () { cd "$SRC/gems/$1" }
scd () { cd "$SRC/$1" }

colours()
{
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

# Fix postgres
fixpg()
{
  rm /opt/homebrew/var/postgres/postmaster.pid
  brew services restart postgres
}


# theme {{{1
export CLICOLOR=1

# mysql
export MYSQL_PS1="\d> "

# tmux
ide() { "$DOTFILES/ide.sh" }

# stuff
alias lsl="ls -l"
alias lsla="ls -la"

alias gs="git status -s"
alias gb="git branch"
alias gc="git commit"
alias gA="git commit --amend --no-edit"
alias grim="git rebase -i main"
alias gr="git rebase"
alias gri="git rebase -i"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias gco="git checkout"
alias gl="git log --pretty=format:'%Cred%H%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gd="git_diff"
alias gdc="git_diff --cached"
alias gD="git diff --name-only"
alias gR="git reset --hard"
alias ga="git add"
alias gap="git add -p"
alias wip="git add . && git commit -m '--wip--'"
alias unwip="git log --oneline | head -1 | awk '{print \$2}' | grep '^\-\-wip\-\-' > /dev/null && git reset head^"

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
  git rev-parse --is-inside-work-tree 2> /dev/null
}

git_diff()
{
  git diff --color=always "$@" | less -R
}

# If it's a git repository, show only the name of the containing directory
current_project()
{
  ref=$(is_git_repo)
  if [ -z $ref ]; then
    echo "${PWD/#$HOME/~}"
  else
    toplevel=$(git rev-parse --show-toplevel)
    [ "$toplevel" != "" ] && echo "$(basename $toplevel)"
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
%(?.%{%F{108}%} *.%{%F{167}%} *)%{%F{253}%}%b '


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

# tmux
alias ta="tmux attach-session -t "

# tasks {{{1
alias -g ctags="/usr/local/bin/ctags -R -f tags --exclude=.git --exclude=log --exclude=public --exclude=tmp --exclude=app/assets --exclude=vendor"

# And so on {{{1
bindkey -e
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
# bindkey -M viins 'jk' vi-cmd-mode

# zfz {{{1
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  export FZF_TMUX=1
  # export FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD | grep -v "fonts\/*" | grep -v "images\/*" | grep -v "db\/*" | grep -v "public\/*" || find * -name ".*" -prune -o -type f -print -o -type l -print) 2> /dev/null'
  export FZF_DEFAULT_COMMAND='ag -g "" --ignore-dir db --ignore-dir tmp --ignore-dir log --ignore-dir public'
fi

# Shell tools {{{1
#
if which brew > /dev/null; then
  autojump_path="$(brew --prefix)/etc/profile.d/autojump.sh"
  [ -f "$autojump_path" ] && . "$autojump_path"

  zsh_auto_suggest_path="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$zsh_auto_suggest_path" ] && . "$zsh_auto_suggest_path"

  zsh_syntax_hilite_path="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [ -f "$zsh_syntax_hilite_path" ] && . "$zsh_syntax_hilite_path"
fi

# asdf
. /opt/homebrew/opt/asdf/asdf.sh

# gggit
ssh-add ~/.ssh/github

[ -f "$HOME/.privaterc" ] && . "$HOME/.privaterc"

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# opam configuration
[[ ! -r /Users/andrewhaust/.opam/opam-init/init.zsh ]] || source /Users/andrewhaust/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
