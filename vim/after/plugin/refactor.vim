function! s:refactor(args, first, last) abort
  " Get selection type
  let parts = split(a:args, ' ')
  let type = parts[0]
  let method = join(parts[1:], ' ')
  if match(type, '\v^pri') >= 0
    call s:refactor_private(method, a:first, a:last)
  endif
endfunction

function! s:refactor_private(name, first, last) abort
  let method = ["def " . a:name] + getline(a:first, a:last) + ["end"]
  exec "keepjumps delete_" (a:last - a:first) + 1
  let fromline = line('.')
  call append(fromline - 1, a:name)
  redraw
  normal k==

  let startline = search('\v\s?(module|class)', 'nb')
  if startline
    let indentlvl = matchstr(getline(startline), '\v^\s+')
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

" https://stackoverflow.com/a/6271254/1181571
function! s:get_visual_selection()
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return lines
endfunction

command! -nargs=1 -range Private call s:refactor_private(<f-args>, <line1>, <line2>)
command! -nargs=1 -range Refactor call s:refactor(<f-args>, <line1>, <line2>)
