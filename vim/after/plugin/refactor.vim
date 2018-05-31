function! s:refactor_private(name, first, last) abort
  let method = ["def " . a:name] + getline(a:first, a:last) + ["end"]
  exec "delete_" (a:last - a:first) + 1
  call append(line('.') - 1, a:name)
  normal k==

  let cmline = search('\v\s?(module|class)', 'nb')
  if cmline
    exec "normal!" cmline."gg^"
    let startline = line('.')
    keepjumps normal %
    let stopline = line('.')
    keepjumps normal %

    let privline = search('\v\s?private', 'n', stopline)
    if !privline
      let privline = search('\v\s?private', 'nb', startline)
    endif

    if privline
      exec "keepjumps normal!" privline."gg"
      call append(privline, [''] + method)
    else
      exec "keepjumps normal!" stopline."gg"
      keepjumps normal! Oprivate
      call append(line('.'), [''] + method)
    endif

    keepjumps normal! jj^V
    normal %
    keepjumps normal! =^
  endif
endfunction

command! -nargs=1 -range Private call s:refactor_private(<f-args>, <line1>, <line2>)
