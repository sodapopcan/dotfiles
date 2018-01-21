command! -buffer -nargs=0 UpdateRubyHashSyntax %s/:\([^ ]*\)\(\s*\)=>/\1:/g

augroup Sinatra
  autocmd!
  autocmd BufEnter *
        \ if &ft ==# 'ruby' && !exists(':Emigration') |
        \   command! -buffer -nargs=0 Emigration exec "e db/migrate/" . system("ls -t db/migrate | head -1") |
        \ endif
augroup END
