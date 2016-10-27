nnoremap <silent> g<cr> :!python %<cr>

set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set shiftround

" Switches between a file and it's test file using :A
if !exists('*s:switch_test_file')
  function! s:switch_test_file()
    let fullpath = expand('%')
    let file = fullpath
    let test_prefixes = ['test_', 'test/', 'tests/']
    let test_prefix = ''
    let is_test_file = 0

    " Check if it's a test file
    for prefix in test_prefixes
      if match(fullpath, prefix) > -1
        let test_prefix = prefix
        let is_test_file = 1
        break
      endif
    endfor

    if is_test_file
      let file = substitute(fullpath, test_prefix, '', '')
    else
      for prefix in test_prefixes
        let file = prefix . fullpath
        if filereadable(file)
          break
        endif
      endfor
    endif

    if fullpath != file
      exec ":edit " . file
    else
      echo "No alternate file found"
    endif
  endfunction
  command! -nargs=0 A call <SID>switch_test_file()
endif
