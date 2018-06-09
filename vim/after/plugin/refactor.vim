function! s:refactor(first, last, ...) abort
  let iname = a:1
  let itype = 0
  let ipath = 0

  if exists('a:2')
    if match(a:2, '\v^:') >= 0
      let ipath = substitute(a:2, '\v^:', '', '')
    elseif match(a:2, '\v:') >= 0
      let [itype, ipath] = split(a:2, ':')
    else
      let itype = a:2
    endif
  endif

  if !itype
    if match(iname, '\v\(\)$') >= 0
      let itype = 'method'
    elseif match(iname, '\v\=$') >= 0
      let itype = 'variable'
    elseif match(iname, '\v^[A-Z][a-zA-Z]') >= 0
      let itype = 'module'
    elseif match(iname, '\v^[A-Z][A-Z_]+') >= 0
      let itype = 'constant'
    elseif visualmode() ==# 'v'
      let itype = 'variable'
    else
      let itype = 'method'
    endif
  endif

  if visualmode() ==# 'v'
    let selection = s:get_charwise_selection()
  else
    let selection = s:get_linewise_selection(a:first, a:last)
  endif

  if itype == 'variable'
    exec "normal! a".iname."\<esc>O".iname." = ".join(selection, "\n")."\<esc>"
  else
    call s:refactor_private(iname, selection)
  endif
endfunction

function! s:get_charwise_selection() abort
  let z = copy(@z)
  normal! gv"zd
  let selection = copy(@z)
  let @z = z

  return split(selection, "\n")
endfunction

function! s:get_linewise_selection(first, last) abort
  let selection = getline(a:first, a:last)
  exec "keepjumps delete_" (a:last - a:first) + 1

  return selection
endfunction

function! s:refactor_private(name, selection) abort
  let method = ["def " . a:name] + a:selection + ["end"]
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
command! -nargs=+ -range Refactor call s:refactor(<line1>, <line2>, <f-args>)
