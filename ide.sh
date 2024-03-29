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

if [ -z "$WORK_COMPUTER" ]; then
  main_session=andrwe
else
  main_session=payitoff
fi

# main session
if tmux ls | grep -q "$main_session"; then
  echo ""${main_session}" session already exists."
else
  cd "~/src/$main_session"
  do_web_dev_session "$main_session"
  tmux bind -r M-a switch-client -t "$main_session"
  tmux send-keys "(pgrep postgres > /dev/null || pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start) && \
    clear && \
    e" C-m

  tmux select-pane -D
  tmux send-keys "rails c" C-m
  tmux select-pane -R
  tmux send-keys "rails s" C-m
  tmux select-window -t 2
  tmux send-keys  "sleep 5 && clear && psql ${main_session}_development" C-m
  tmux new-window
  tmux rename-window ssh
  tmux new-window
  tmux rename-window notes
  tmux send-keys "cd ~/notes && vim -c 'Goyo' ${main_session}.md" C-m
  tmux select-window -t 1
  # tmux select-pane -t 0

  tmux -2 attach-session -t "$main_session"
fi
