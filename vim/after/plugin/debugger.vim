" Debugging
" Takes a variable name as an arg and will output a debug log
" statement dependent on the language
" With no argument will use the word under the cursor
nnoremap <silent> dI :call <sid>debug()<CR>

function! s:debug()
  let token = expand('<cword>')
  let output = []
  let skip_patterns = []
  let terminal_patterns = []
  let continuations = []

  if &ft ==# 'vim'
    let output = 'echom "'.token.'=".'.token
    let skip_patterns = []
  elseif &ft ==# 'elixir'
    let output = ['dbg('.token.')']
    let skip_patterns = ['^\s*|>', '\s*,$', '^\s*[a-z_]\+:', '\s*%{$', '\s*[$', '=$']
    let terminal_patterns = ['\s*]$', '\s*}$']
    let continuations = ['\s|>']
  elseif &ft ==# 'ruby'
    let output = ['p "#" * 80', 'p '.token, 'p "#" * 80']
  elseif &ft =~# '^javascript'
    let output = 'console.log("'.token.'", '.token.')'
  else
    return
  endif

  let current_line_number = line('.')
  let next_line_number = current_line_number + 1

  " Special case for Elixir
  if s:on_pipe()

    let output = ['|> dbg()']
    return s:append(current_line_number, output)
  endif

  let line_number = current_line_number
  while s:line_match(line_number, skip_patterns)
    if s:line_match(line_number, terminal_patterns)
      break
    else
      let line_number = line_number + 1
    endif
  endwhile

  call s:append(line_number, output)
endfunction

function! s:match(string, pattern)
  return match(a:string, a:pattern) >= 0
endfunction

function! s:line_match(linenr, patterns)
  for pattern in a:patterns
    if match(getline(a:linenr), pattern) >= 0
      return 1
    endif
  endfor

  return 0
endfunction

function! s:append(linenr, output)
  call append(a:linenr, a:output)
  let current_linenr = line('.')
  exec "keepjumps" a:linenr + 1
  exec "silent normal! ".len(a:output)."=="
  exec "keepjumps" current_linenr
endfunction

function! s:on_pipe()
  return index(["|", ">"], getline('.')[col('.')-1]) != -1 && match(getline("."), '^\(\s\+\)\?|>') >= 0
endfunction

function! s:get_syn_groups()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
