" refactor.vim
" https://github.com/sodapopcan/dotfiles/vim/after/plugin/refactor.vim
" 
" Differences from ruby-refactoring:
"
" * Don't try and pull out variables when extracting a method
" * Allow for private methods
" * One-command API (with a bang variant): `:Refactor`
" * No default mappings to override--make yer own mappings!
" * Tries to do the right thing based on selection type:
"   - with characterwise selection on one line, extract to a variable
"   - with multi-line selection then extract to a method
"
" Some unrelenting caveats:
"
" * refactor.vim assumes your file is properly formatted at the time you
"   refactor.  In the name of simplicity and not relying on other plugins, some
"   very basic parsing is done to deterime where the refactoring should be
"   performed.  If sloppiness is part of your MO, this is not the tool for you.
" 
" API:
"
"   With a linewise selection, extract a public method below the current one or,
"   with a characterwise selection, extract a local variable.
"
"     :Refactor some_method_name(some, vars)
"
"
"   Extract a private method, adding the private keyword if not already present:
"
"     :Refactor some_method_name(some, vars) private
"
"
"   If first line of selection is a method defintion, extract to a module.  The
"   first arg will be the module name, the second will be the write path.  With
"   no extension, the last path fragment will be assumed to be a directory and
"   the file name will be the first arg.
"
"     :Refactor! some_module wherever/yup.rb
"
function! s:refactor(args, first, last) abort
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
command! -nargs=1 -range Refactor call s:refactor(<f-args>, <line1>, <line2>)
