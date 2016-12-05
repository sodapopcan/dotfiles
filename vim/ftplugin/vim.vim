set foldmethod=marker

if expand('%:t') == 'vimrc'
  command! -nargs=1 P exec "silent normal! oPlug '" . <f-args> . "'<esc>:w<cr>:so %<cr>"
endif
