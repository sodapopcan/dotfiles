let s:return_file = ''

function! s:grep(arg) abort
  if a:arg ==# ''
    call s:warn("No pattern given")
    return
  endif

  let s:return_file = expand('%')

  let output = system("git --no-pager grep --no-color -n " . a:arg)
  if len(output)
    cgetexpr output
    silent botright copen
    nnoremap <buffer> o :call <SID>edit_file()<CR>
    nnoremap <buffer> go :call <SID>preview_file()<CR>
    nnoremap <buffer> q :cclose<CR>
    nnoremap <buffer> <c-c> <c-c>:cclose<CR>:call <SID>edit_return_file()<CR>
  else
    call s:warn("No results for " . a:arg)
  endif
endfunction

function! s:edit_file()
  let [filename, linenr] = split(getline('.'), '|')[0:1]
  keepjumps wincmd p
  exec "edit " . filename
  exec "keepjumps " . linenr
endfunction

function! s:preview_file() abort
  call s:edit_file()
  keepjumps wincmd p
endfunction

function! s:edit_return_file()
  if s:return_file ==# ''
    return
  endif
  exec "keepjumps edit" s:return_file
endfunction

function! s:warn(str) abort
  echohl WarningMsg
  echomsg a:str
  echohl None
  let v:warningmsg = a:str
endfunction

command! -nargs=? -complete=file -bar Grep call s:grep(<q-args>)
command! -nargs=0 GrepClear call s:edit_return_file()
