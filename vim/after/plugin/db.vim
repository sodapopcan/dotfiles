" DadbodUI
"
" see also vim/after/ftplugin/dbout.vim
if exists('g:loaded_dbui')
  nnoremap db :DB<space>
  nnoremap <silent> dB :DBUI<cr>
endif
