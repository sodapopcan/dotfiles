#!/bin/zsh

do_web_dev_session() {
  tmux -2 new-session -d -s $1
  tmux rename-window main
  tmux split-window -v
  tmux resize -x 30
  tmux split-window -h
  tmux resize-pane -y 6
  tmux select-pane -D
  tmux new-window
  tmux rename-window db
  tmux select-window -t 1
  tmux send-keys "e" C-m
}

# Dotfiles, notes, vimscript projects and whatnot
cd ~/dotfiles
tmux -2 new-session -d -s home
tmux rename-window dotfiles
tmux send-keys "e zshrc" C-m
tmux send-keys "|"
tmux send-keys ":e vimrc" C-m
tmux split-window -h
tmux resize-pane -x 9
tmux send-keys "colours | less -R" C-m
tmux select-pane -L
tmux bind -r M-f switch-client -t home


# OMX
cd ~/src/omx
do_web_dev_session omx
tmux bind -r M-a switch-client -t omx

tmux select-pane -D
tmux send-keys "rails c" C-m
tmux select-pane -R
tmux send-keys "rails s" C-m
tmux select-window -t 2
tmux send-keys "psql" C-m
# tmux send-keys "\c production_hub_development" C-m
tmux new-window
tmux rename-window ssh
tmux new-window
tmux rename-window notes
tmux select-window -t 1
tmux select-pane -t 0

tmux -2 attach-session -t omx
