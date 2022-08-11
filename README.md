# D-D-Dotfiles

These are my personal config files that I have only ever used on macOS.

## Cut and Paste Shell Commands

`chsh -s /bin/zsh`

`git clone git@github.com:sodapopcan/dotfiles.git ~/dotfiles`

`cd ~/dotfiles`

`./install`

## Manual Steps

### Alacritty

In order to use `cmd-q` in the way I want to use it, `cmd-q` must be disabled at
the OS level.  Go to Preferences -> Keyboard -> Shortcuts -> App Shortcuts and
override `cmd-q` for Alacritty to something else.  I do `cmd-shift-ctl-q`.
