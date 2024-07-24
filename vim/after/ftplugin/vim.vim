" Jump between functions
" nnoremap <silent> <buffer> <C-N> :call search('\v^function', 'W')<CR>
" nnoremap <silent> <buffer> <C-P> :call search('\v^function', 'bW')<CR>

" Plugin dev
nnoremap <buffer> <silent> & :source %<cr>:mess clear<cr>:echo "Reloaded ".expand('%')." and cleared messages"<CR>

nnoremap <buffer> <c-k> K

if exists('g:loaded_plug')
  if expand('%:t') == 'vimrc'
    command! -nargs=* -bang P call s:add_plugin(<bang>0, <f-args>)
    if !exists('*s:add_plugin')
      function! s:add_plugin(bang, ...)
        if a:0 > 0
          exec "silent normal! oPlug '" . a:1 . "'\<esc>:w\<cr>:so %\<cr>"
          if !a:bang
            PlugInstall
          endif
        else
          exec "normal! gg/\call plug#begin\<CR>zo"
        endif
      endfunction
    endif
  endif
endif
