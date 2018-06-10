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
  exec "normal! a".a:name."\<esc>O".a:name." = ".join(a:selection, "\n")."\<esc>"
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
    let deflinenr = search('\v^'.indentlvl.'def', 'nbW')
  endwhile

  let modulelinenr = search('\v\s?(module|class)', 'nbW')

  " If we aren't, append a new method below
  if !deflinenr
    if modulelinenr " Inside a module so make it a class method
      let output = [''] + [substitute(method[0], 'def ', 'def self.', '')] + method[1:]
    else " Just in a classless script, make it a regular method
      let output = [''] + method
    endif

    call append(fromline, output)
    redraw
    normal m'
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

    let accesslinenr = search('\v\s?'.a:type.'$', 'nW', stopline)
    if !accesslinenr
      let accesslinenr = search('\v\s?'.a:type.'$', 'nbW', modulelinenr)
    endif

    if accesslinenr
      let output = [''] + method
      call append(accesslinenr, output)
      let jumpline = accesslinenr + 2
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
  exec fromline
  exec "normal! ".(jumpline + 2)."ggzz"
endfunction

command! -nargs=+ -range Refactor call s:refactor(<line1>, <line2>, <f-args>)
