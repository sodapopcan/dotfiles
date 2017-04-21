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
}

# Dotfiles, notes, vimscript projects and whatnot
if tmux ls | grep -q home; then
  echo "Home session already exists."
else
  cd $DOTFILES
  tmux -2 new-session -d -s home
  tmux rename-window dotfiles
  tmux send-keys "e vimrc -c 'silent Obsession'" C-m
  tmux split-window -h
  tmux resize-pane -x 9
  tmux send-keys "colours | less -R" C-m
  tmux select-pane -L
  tmux bind -r M-f switch-client -t home
fi

# inkcling
if tmux ls | grep -q inkcling; then
  echo "inkcling session already exists."
else
  cd ~/src/inkcling
  do_web_dev_session inkcling
  tmux bind -r M-a switch-client -t inkcling
  tmux send-keys "(pgrep postgres > /dev/null || pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start) && \
    clear && \
    e" C-m

  tmux select-pane -D
  # tmux send-keys "rails c" C-m
  tmux select-pane -R
  # tmux send-keys "rails s" C-m
  tmux select-window -t 2
  tmux send-keys  "sleep 5 && clear && psql inkcling_development" C-m
  tmux new-window
  tmux rename-window ssh
  tmux new-window
  tmux rename-window notes
  tmux send-keys "cd ~/notes && vim -c 'Goyo' inkcling.md" C-m
  tmux select-window -t 1
  # tmux select-pane -t 0

  # tmux -2 attach-session -t inkcling
fi

# OMX
if tmux ls | grep -q omx; then
  echo "OMX session already exists."
else
  cd ~/src/omx
  do_web_dev_session omx
  tmux bind -r M-s switch-client -t omx
  tmux send-keys "(pgrep postgres > /dev/null || pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start) && \
    (pgrep searchd > /dev/null || searchd --config $HOME/src/omx/config/development.sphinx.conf) && \
    clear && \
    e" C-m

  tmux select-pane -D
  # tmux send-keys "rails c" C-m
  tmux select-pane -R
  # tmux send-keys "rails s" C-m
  tmux select-window -t 2
  tmux send-keys  "sleep 5 && clear && psql omx_development" C-m
  tmux new-window
  tmux rename-window ssh
  tmux new-window
  tmux rename-window notes
  tmux send-keys "cd ~/notes && vim -c 'Goyo' notes.md" C-m
  tmux select-window -t 1
  # tmux select-pane -t 0

  tmux -2 attach-session -t omx
fi
