" Notes
const s:MY_NOTES = 'MY_NOTES'

command! -nargs=0 -bang Notes call s:Notes(<bang>0, <q-mods>)

function! s:Notes(bang, mods) abort
  if !a:bang
    let cmd = a:mods ==# '' ? 'vsplit' : 'split'
    exec a:mods cmd '+set\ filetype=markdown\|\set\ bufhidden=delete ' .. s:MY_NOTES
  else
    call s:setup_buf(s:get_section())
  endif
endfunction

command! -nargs=0 Todo call s:Todo()

function! s:Todo() abort
  let notes_file = findfile(s:MY_NOTES, '.;')

  if notes_file ==# ''
    echom "No notes file"

    return
  endif

  let todos = systemlist('rg ''^\[ '' ' . notes_file)

  if empty(todos)
    return
  endif

  call s:setup_buf(todos)
endfunction

function! s:setup_buf(contents) abort
  new
  setlocal buftype=nofile bufhidden=delete
  call append(0, a:contents)
  delete_
  1
  nnoremap <buffer> <silent> <CR> :call <SID>toggle_todo()<CR>
endfunction

function! s:toggle_todo() abort
  if getline('.') !~# '^\s*\['
    return
  endif

  let view = winsaveview()

  keeppatterns %s/\[\*\]/\[ \]/e

  call winrestview(view)

  keeppatterns s/\[\ \]/\[*\]

  call winrestview(view)
endfunction

function! s:curr_branch() abort
  system('command -v git')

  if v:shell_error > 0
    return ''
  endif

  return system('git branch | grep \* | sed ''s/\* //''')
endfunction

function! s:get_section() abort
  return matchstr(readfile(s:MY_NOTES), '^#\{2}\s\+\_.\{-}\ze\%(^#\{2}\)')
endfunction
