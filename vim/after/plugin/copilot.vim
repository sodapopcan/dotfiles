" This allows using <c-e> to accept Copilot suggestions while still keeping
" rsi.vim's functionality.

if exists(':Copilot') != 2
  finish
endif

let g:copilot_no_tab_map = v:true
inoremap <expr> <c-j> copilot#Accept("\<Lt>End>")
imap <c-s> <Plug>(copilot-suggest)
imap <c-l> <Plug>(copilot-accept-word)
imap <c-;> <Plug>(copilot-accept-line)

let g:copilot_filetypes = {
      \   '*': v:false,
      \ }
