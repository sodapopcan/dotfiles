function! s:refactor_private(name, first, last) abort
  let method = ["def " . a:name] + getline(a:first, a:last) + ["end"]
  exec "keepjumps delete_" (a:last - a:first) + 1
  let fromline = line('.')
  call append(fromline - 1, a:name)
  redraw
  normal k==

  let startline = search('\v\s?(module|class)', 'nb')
  if startline
    let indentlvl = matchstr('\v^\s+', getline(startline))
    let stopline = search('\v^' . indentlvl . 'end$', 'n')

    let privline = search('\v\s?private', 'n', stopline)
    if !privline
      let privline = search('\v\s?private', 'nb', startline)
    endif

    if privline
      let output = [''] + method
      call append(privline, output)
      let jumpline = privline
    else
      let output = ['', 'private', ''] + method
      let jumpline = stopline - 1
      call append(jumpline, output)
    endif
    redraw

    keepjumps exec jumpline
    exec "normal! =".len(output)."\<cr>"
    keepjumps exec fromline
    exec "normal! ".(jumpline + 2)."ggzz"
  endif
endfunction

command! -nargs=1 -range Private call s:refactor_private(<f-args>, <line1>, <line2>)
