function! s:extract_variable(prepend, template) abort
  let template = substitute(a:template, "{id}", @., '')
  call append(line(".") - a:prepend, template)
  exec "normal! ".(a:prepend ? 'k' : 'j')."$==p"
endfunction

augroup Extracts
  autocmd!
  autocmd FileType vim nnoremap <buffer> ]<cr> :call <SID>extract_variable(0, "let {id} = ")<CR>
  autocmd FileType vim nnoremap <buffer> [<cr> :call <SID>extract_variable(1, "let {id} = ")<CR>
  autocmd FileType elixir nnoremap <buffer> ]<cr> :call <SID>extract_variable(0, "{id} = ")<CR>
  autocmd FileType elixir nnoremap <buffer> [<cr> :call <SID>extract_variable(1, "{id} = ")<CR>
augroup END

