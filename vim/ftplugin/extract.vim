" let template = "let {id} = "

" function! s:extract_variable(prepend, template) abort
"   let template = substitute(a:template, "{id}", @., '')
"   call append(line(".") - a:prepend, template)
"   exec "normal! ".(a:prepend ? 'k' : 'j')."$==p"
" endfunction

" nnoremap <buffer> yvp :call <SID>extract_variable(0, template)<CR>
" nnoremap <buffer> yvP :call <SID>extract_variable(1, template)<CR>
