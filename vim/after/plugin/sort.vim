" Works just like :sort but fix commas in languages that don't use trailing
" commas.

if exists('g:loaded_sort')
  finish
endif
let g:loaded_sort = 1

function s:sort_range(bang, args, first_lnum, last_lnum) abort
  exec a:first_lnum .. ',' .. a:last_lnum .. 'sort' .. (a:bang ? '!' : '') .. ' ' .. a:args

  for curr_lnum in range(a:first_lnum, a:last_lnum)
    let text = getline(curr_lnum)
    let last_char = text[-1:]

    if last_char != ',' && curr_lnum != a:last_lnum
      call setline(curr_lnum, text .. ',')
    elseif last_char == ',' && curr_lnum == a:last_lnum
      call setline(curr_lnum, text[:-2])
    endif
  endfor
endfunction

command! -range -bang -nargs=* Sort call s:sort_range(<bang>0, <q-args>, <line1>, <line2>)
