setlocal nowrap norelativenumber number

nnoremap <buffer> H :res 999<cr>gg
nnoremap <buffer> M :res 30<cr>gg
nnoremap <buffer> L :res 10<cr>gg

nnoremap <silent> <buffer> O :call <SID>open_file()<CR>
nnoremap <silent> <buffer> go :call <SID>preview_file()<CR>
" nnoremap <silent> <buffer> o :call <SID>open_file_and_close_qf()<CR>
nnoremap <silent> <buffer> o :.cc<cr><bar>:cclose<cr>
nnoremap <silent> <buffer> I :call <SID>open_screenshot()<CR>
nnoremap <silent> <buffer> q :quit<CR>
nnoremap <silent> <buffer> <c-c> <c-c>:quit<CR>:call <SID>edit_return_file()<CR>

function! s:open_file() abort
  pclose
let line = getline(".")
  let filename_with_linenr = matchstr(line, '[a-z\/_\-\.]\+\(:|\|\)?\d\+')
  if filename_with_linenr !=# ""
    let [filename, linenr] = split(filename_with_linenr, ":")
    wincmd w
    exec ":edit ".filename
    exec "keepjumps ".linenr
  else
    .cc
  endif
endfunction

function! s:open_file_and_close_qf() abort
  call s:open_file()
  cclose
endfunction

function! s:preview_file() abort
  let [filename, linenr] = split(getline('.'), '|')[0:1]
  exec "pedit +".linenr filename
endfunction

function! s:open_screenshot() abort
  if search("screenshots/failures")
    normal gx
  else
    echo "No screenshot found"
  endif
endfunction
