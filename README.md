# D-D-Dot Files #

These are my personal config files that I have only ever used on OS X.  This
README serves as a place to keep track of any manual config I would have to do
in setting up a brand new system (as opposed to setting up some extended
automated fanciness).

## Cut and Paste Shell Commands

### Use zsh
`chsh -s /bin/zsh`

### Clone my dotfiles repo which will mostly configure my terminal
`git clone git@github.com:sodapopcan/dotfiles.git ~/dotfiles`

### Link-up the appropriate files
```shell
ln -s ~/dotfiles/zshrc ~/.zshrc && \
ln -s ~/dotfiles/zshrc ~/.zshenv && \
ln -s ~/dotfiles/zlogin ~/.zlogin && \
ln -s ~/dotfiles/vimrc ~/.vimrc && \
ln -s ~/dotfiles/vim ~/.vim && \
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf && \
ln -s ~/dotfiles/bashrc ~/.bashrc && \
ln -s ~/dotfiles/gitconfig ~/.gitconfig && \
ln -s ~/dotfiles/cvsignore ~/.cvsignore
```

### Vundle
`git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

### Use C-W everywhere (including OS X apps)
`mkdir ~/Library/KeyBindings`
`echo "{\n\t\"^w\" = \"deleteWordBackward:\";\n}" >> ~/Library/KeyBindings/DefaultKeyBinding.dict`
Got this from [here](https://coderwall.com/p/rhiiba/ctrl-w-everywhere).

## Manual Set-up

### iTerm
Preferences -> Profiles -> Keys
  - `Left option keys acts as: +Esc`

Preferences -> Keys
  - `Left command key: Left Option`
  (The left command key gets used for the tmux prefix)
  - Need to download Karabiner (https://pqrs.org/osx/karabiner/index.html.en)
    and remap the right-hand option key to control.

### OS X
System Preferences -> Keyboard -> Modifier Keys...
  - `Option Key: Control`
