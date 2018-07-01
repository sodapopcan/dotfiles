setlocal nowrap norelativenumber number

nnoremap <silent> <buffer> o :call <SID>open_file()<CR>
nnoremap <silent> <buffer> go :call <SID>preview_file()<CR>
nnoremap <silent> <buffer> O :call <SID>open_file_and_close_qf()<CR>
nnoremap <silent> <buffer> q :cclose<CR>
nnoremap <silent> <buffer> <c-c> <c-c>:cclose<CR>:call <SID>edit_return_file()<CR>

function! s:open_file()
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
