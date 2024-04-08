highlight ExUnitDebugLocation ctermfg=74
highlight TestError ctermbg=red

syn match ExUnitDebugLocation    "\[\(lib\|test\).*\]$"
syn match TestError "\<Err:"
