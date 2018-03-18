#!/usr/bin/env bash

# Backup vimfiles and create clean versions
if [ -d vim.bak -a -f vimrc.bak ]; then
  rm vimrc
  rm -rf vim
  mv vim.bak vim
  mv vimrc.bak vimrc
else
  mv vim vim.bak
  mv vimrc vimrc.bak
  mkdir -p vim/autoload
  mkdir vim/plugins
  cat <<VIMRC > vimrc
set nocompatible

nnoremap jk <esc>
nnoremap <cr> :w<cr>

call plug#begin('~/.vim/plugins')
  Plug 'tpope/vim-fugitive' 
  Plug 'sodapopcan/vim-twiggy'
call plug#end()
VIMRC

  ln -s vimrc vim/init.vim
  cp vim.bak/autoload/plug.vim vim/autoload
fi
