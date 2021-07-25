function! s:extract_variable(prepend, template) abort
  let template = substitute(a:template, "{id}", @., '')
  call append(line(".") - a:prepend, template)
  exec "normal! ".(a:prepend ? 'k' : 'j')."$==p"
endfunction

autocmd FileType vim nnoremap <buffer> yvp :call <SID>extract_variable(0, "let {id} = ")<CR>
autocmd FileType vim nnoremap <buffer> yvP :call <SID>extract_variable(1, "let {id} = ")<CR>
