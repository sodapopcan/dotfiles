#!/usr/bin/env bash

DOTFILES="$HOME/dotfiles"
if [ -e "$DOTFILES/vimrc" ]; then
  echo "Already installed"
  exit 0
fi

echo "Symlinking:"
ln -s ~/dotfiles/zshrc ~/.zshrc
echo "  * zshrc"
ln -s ~/dotfiles/zshrc ~/.zshenv
echo "  * zsenv"
ln -s ~/dotfiles/zlogin ~/.zlogin
echo "  * zlogin"
ln -s ~/dotfiles/vimrc ~/.vimrc
echo "  * vimrc"
ln -s ~/dotfiles/bashrc ~/.bashrc
echo "  * bashrc"
ln -s ~/dotfiles/vim ~/.vim
echo "  * vim/"
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
echo "  * tmux.conf"
ln -s ~/dotfiles/gitconfig ~/.gitconfig
echo "  * gitconfig"
ln -s ~/dotfiles/cvsignore ~/.cvsignore
echo "  * gitignore (actually cvsignore)"

echo "Use ctrl-w everywhere on macOS"
mkdir ~/Library/KeyBindings
echo "{\n\t\"^w\" = \"deleteWordBackward:\";\n}" >> ~/Library/KeyBindings/DefaultKeyBinding.dict
