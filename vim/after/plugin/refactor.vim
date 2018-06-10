let s:valid_types = [
      \ 'private',
      \ 'protected',
      \ 'public',
      \ 'module',
      \ 'class',
      \ 'variable'
      \ ]

function! s:refactor(first, last, ...) abort
  let iname = a:1
  let itype = ''
  let ipath = ''

  if exists('a:2')
    if match(a:2, '\v^:') >= 0
      let ipath = substitute(a:2, '\v^:', '', '')
    elseif match(a:2, '\v:') >= 0
      let [itype, ipath] = split(a:2, ':')
    else
      let itype = a:2
    endif
  endif

  if len(itype)
    for type in s:valid_types
      if match(type, '\v^'.itype) >= 0
        let itype = type
        break
      endif
    endfor
    if index(s:valid_types, itype) < 0
      echom "Unrecognized type ".itype

      return
    endif
  else
    if match(iname, '\v\(\)$') >= 0
      let itype = 'method'
    elseif match(iname, '\v\=$') >= 0
      let itype = 'variable'
    elseif match(iname, '\v\C^[A-Z][a-zA-Z]+') >= 0
      let itype = 'module'
    elseif match(iname, '\v\C^[A-Z][A-Z_]+') >= 0
      let itype = 'constant'
    elseif visualmode() ==# 'v'
      let itype = 'variable'
    elseif visualmode() ==# 'V'
      let itype = 'public'
    else
      let itype = 'public'
    endif
  endif

  if visualmode() ==# 'v'
    let selection = s:get_charwise_selection()
  else
    let selection = s:get_linewise_selection(a:first, a:last)
  endif

  if itype ==# 'variable'
    call s:extract_variable(iname, selection)
  else
    call s:extract_method(iname, selection, itype)
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

function! s:extract_variable(name, selection) abort
  exec "normal! a".iname."\<esc>O".iname." = ".join(selection, "\n")."\<esc>"
endfunction

function! s:extract_method(name, selection, type) abort
  let method = ["def " . a:name] + a:selection + ["end"]
  let fromline = line('.')
  call append(fromline - 1, a:name)
  redraw
  normal k==

  " Are we inside a method?
  let indentlvl = matchstr(getline(fromline), '\v^\s+')
  let deflinenr = 0
  while !deflinenr && len(indentlvl)
    let indentlvl = substitute(indentlvl, repeat(' ', shiftwidth()), '', '')
    let deflinenr = search('\v^'.indentlvl.'def', 'nb')
  endwhile

  let output = [''] + method

  " If we aren't, append a new method below
  if !deflinenr
    call append(fromline, output)
    exec 'normal! ='.len(output).'='

    return
  endif

  let line = line('.')
  exec deflinenr
  let defendlinenr = search('\v^'.indentlvl.'end$', 'n')
  exec line

  let startline = search('\v\s?(module|class)', 'nb')

  if !startline || a:type ==# 'public'
    call append(defendlinenr, output)
    let jumpline = search('\v^\s+def', 'n')
  elseif a:type ==# 'private' || a:type ==# 'protected'
    let indentlvl = matchstr(getline(startline), '\v^\s+')
    let stopline = search('\v^'.indentlvl.'end$', 'n')

    let accessline = search('\v\s?'.a:type.'$', 'n', stopline)
    if !accessline
      let accessline = search('\v\s?'.a:type.'$', 'nb', startline)
    endif

    if accessline
      let output = [''] + method
      call append(accessline, output)
      let jumpline = accessline
    else
      let output = ['', a:type, ''] + method
      let jumpline = stopline - 1
      call append(jumpline, output)
    endif
    redraw
  endif

  keepjumps exec jumpline
  exec "normal! =".(len(output) + 2)."\<cr>"
  keepjumps exec fromline
  exec "normal! ".(jumpline + 2)."ggzz"
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
