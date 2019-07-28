command! -buffer -nargs=0 UpdateRubyHashSyntax %s/:\([^ ]*\)\(\s*\)=>/\1:/g

augroup Sinatra
  autocmd!
  autocmd BufEnter *
        \ if &ft ==# 'ruby' && !exists(':Emigration') |
        \   command! -buffer -nargs=0 Emigration exec "e db/migrate/" . system("ls -t db/migrate | head -1") |
        \ endif
augroup END

nnoremap <buffer> <silent> g@ :call <SID>insert_instance_vars()<CR>

function! s:insert_instance_vars() abort
  let linenr = line('.') - 1
  let line = getline(linenr)

  if getline('.') !=# ''
    return
  endif

  if match(line, '\v(\s+)?def initialize\([a-zA-Z0-9_, ]+\)') < 0
    return
  endif

  let matches = matchlist(line, '\v\(([a-zA-Z0-9_, ]+)\)')
  let vars = split(substitute(matches[1], ' ', '', 'g'), ',')
  let ivars = []
  let readers = []
  let indent = indent(linenr)
  let length = repeat(' ', (indent + &shiftwidth))
  for var in vars
    call add(ivars, length.'@'.var.' = '.var)
    call add(readers, ':'.var)
  endfor
  let attr_reader = repeat(' ', indent).'attr_reader '.join(readers, ', ')
  call append(linenr, ivars)
  if getline('.') ==# ''
    delete_
  endif
  call append(linenr - 1, [attr_reader, ''])
endfunction
