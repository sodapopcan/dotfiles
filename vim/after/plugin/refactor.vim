function! s:refactor_private(name, first, last) abort
  let method = ["def " . a:name] + getline(a:first, a:last) + ["end"]
  " let range = (a:last - a:first) + 1
  exec "delete_" (a:last - a:first) + 1
  let privlnr = search('^\s\+private', 'nw')
  call append(line('.') - 1, a:name)
  normal k==
  if privlnr
    exec "normal!" privlnr."gg"
    call append(privlnr + 1, [''] + method)
  else
    normal ][Oprivate
    call append(line('.'), [''] + method)
  endif
  normal ]m=am
endfunction

command! -nargs=1 -range Private call s:refactor_private(<f-args>, <line1>, <line2>)

