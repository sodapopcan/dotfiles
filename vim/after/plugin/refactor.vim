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

  let itype = s:resolve_itype(iname, itype)
  let iname = s:resolve_iname(iname)

  if visualmode() ==# 'v'
    let selection = s:exact_charwise_selection()
  else
    let selection = s:exact_linewise_selection(a:first, a:last)
  endif

  if itype ==# 'variable'
    call s:extract_variable(iname, selection)
  else
    call s:extract_method(iname, selection, itype)
  endif
endfunction

function! s:exact_charwise_selection() abort
  let z = copy(@z)
  normal! gv"zd
  let selection = copy(@z)
  let @z = z

  return split(selection, "\n")
endfunction

function! s:exact_linewise_selection(first, last) abort
  let selection = getline(a:first, a:last)
  exec "keepjumps delete_" (a:last - a:first) + 1

  return selection
endfunction

function! s:extract_variable(name, selection) abort
  let cmd = (col(".") == col("$")-1) ? 'a' : 'i'
  exec "normal!" cmd.a:name."\<esc>"
  exec "normal! O".a:name." = ".join(a:selection, "\n")."\<esc>"
endfunction

function! s:extract_method(name, selection, type) abort
  let method = ["def " . a:name] + a:selection + ["end"]
  let originallinenr = line('.')
  call append(originallinenr - 1, a:name)
  redraw
  normal! k==

  " Are we inside a method?
  let indentlvl = matchstr(getline(originallinenr), '\v^\s+')
  let deflinenr = 0
  while !deflinenr && len(indentlvl)
    let indentlvl = substitute(indentlvl, repeat(' ', shiftwidth()), '', '')
    let deflinenr = search('\v^'.indentlvl.'def', 'nbW')
  endwhile

  let modulelinenr = search('\v\C\s?(module|class)', 'nbW')

  " If we aren't, append a new method below
  if !deflinenr
    if modulelinenr " Inside a module so make it a class method
      let output = [''] + [substitute(method[0], 'def ', 'def self.', '')] + method[1:]
    else " Just in a classless script, make it a regular method
      let output = [''] + method
    endif

    call append(originallinenr, output)
    redraw
    normal! m'
    +2
    keepjumps exec 'normal! ='.len(output).'='

    return
  endif

  let output = [''] + method

  let line = line('.')
  exec deflinenr
  let defendlinenr = search('\v^'.indentlvl.'end$', 'nW')
  exec line

  if !modulelinenr || a:type ==# 'public'
    call append(defendlinenr, output)
    let jumpline = defendlinenr + 2
  elseif a:type ==# 'private' || a:type ==# 'protected'
    let indentlvl = matchstr(getline(modulelinenr), '\v^\s+')
    let stopline = search('\v^'.indentlvl.'end$', 'nW')

    let accesslinenr = search('\v\C\s?'.a:type.'$', 'nW', stopline)
    if accesslinenr
      let accessor_below_cursor = 1
    else
      let accesslinenr = search('\v\C\s?'.a:type.'$', 'nbW', modulelinenr)
      if accesslinenr
        let accessor_below_cursor = 0
      endif
    endif

    if accesslinenr
      let output = [''] + method
      if accessor_below_cursor
        call append(accesslinenr, output)
        let jumpline = accesslinenr + 2
      else
        call append(defendlinenr, output)
        let jumpline = defendlinenr + 2
      endif
    else
      let output = ['', a:type, ''] + method
      let appendlinenr = stopline - 1
      call append(appendlinenr, output)
      let jumpline = appendlinenr + 2
    endif
  endif

  redraw

  keepjumps exec jumpline
  keepjumps exec "normal! =".(len(output) + 4)."\<cr>"
  exec originallinenr
  exec "normal! ".(jumpline + 2)."ggzz"
endfunction

function! s:resolve_itype(iname, itype) abort
  if len(a:itype)
    let itype = a:itype
    for type in s:valid_types
      if match(type, '\v^'.itype) >= 0
        let itype = type
        break
      endif
    endfor

    if index(s:valid_types, itype) >= 0
      return itype
    else
      echom "Unrecognized type ".itype
    endif
  else
    if match(a:iname, '\v^_') >= 0
      return 'private'
    elseif match(a:iname, '\v\(\)$') >= 0
      return 'method'
    elseif match(a:iname, '\v\=$') >= 0
      return 'variable'
    elseif match(a:iname, '\v\C^[A-Z][a-zA-Z]+') >= 0
      return 'module'
    elseif match(a:iname, '\v\C^[A-Z][A-Z_]+') >= 0
      return 'constant'
    elseif visualmode() ==# 'v'
      return 'variable'
    elseif visualmode() ==# 'V'
      return 'public'
    else
      return 'public'
    endif
  endif
endfunction

function! s:resolve_iname(iname) abort
  return substitute(a:iname, '\v(^_|\(\)$|\=$)', '', 'g')
endfunction

command! -nargs=+ -range Refactor call s:refactor(<line1>, <line2>, <f-args>)
