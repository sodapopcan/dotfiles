" Usage:
"
"   :Kdb cmd + h / j / k / l
"
" This will results in <kbd class="cmd">cmd</kbd>+<kbd>h</kbd>/<kbd>j</kbd>/<kbd>k</kbd>/<kbd>l</kbd>
"
" Notice + and / are bare.  To include them as keys, use \+ and \/.
"
command! -nargs=1 Kbd call s:kbd(<f-args>) 


function! s:kbd(keys) abort
  let output = '<span class="keys">'

  for key in a:keys->split(' ')
    if key ==# 'cmd'
      let output .= '<kbd class="cmd">cmd</kbd>'
    elseif key ==# '+' || key ==# '/'
      let output .= key
    elseif key =~# '^\' || key ==# '^\'
      let output .= '<kbd>' .. substitute(key, '\', '', '') .. '</kbd>'
    else
      let output .= '<kbd>' .. key .. '</kbd>'
    endif
  endfor

  call append(line('.'), output .. '</span>')
endfunction
