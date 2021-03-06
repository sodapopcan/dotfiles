setlocal nowrap norelativenumber number

nnoremap <silent> <buffer> o :call <SID>open_file()<CR>
nnoremap <silent> <buffer> go :call <SID>preview_file()<CR>
nnoremap <silent> <buffer> O :call <SID>open_file_and_close_qf()<CR>
nnoremap <silent> <buffer> q :quit<CR>
nnoremap <silent> <buffer> <c-c> <c-c>:quit<CR>:call <SID>edit_return_file()<CR>

function! s:open_file() abort
  pclose
  .cc
endfunction

function! s:open_file_and_close_qf() abort
  call s:open_file()
  cclose
endfunction

function! s:preview_file() abort
  let [filename, linenr] = split(getline('.'), '|')[0:1]
  exec "pedit +".linenr filename
endfunction
