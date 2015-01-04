hi Normal              ctermfg=235   ctermbg=15    cterm=NONE
hi Visual              ctermfg=NONE  ctermbg=192   cterm=NONE
hi Comment             ctermfg=23    ctermbg=NONE  cterm=NONE
hi Search              ctermfg=NONE  ctermbg=191   cterm=NONE
hi IncSearch           ctermfg=255   ctermbg=24    cterm=NONE
hi WarningMsg          ctermfg=52    ctermbg=NONE  cterm=NONE
hi ErrorMsg            ctermfg=255   ctermbg=124   cterm=NONE
hi Function            ctermfg=NONE  ctermbg=NONE  cterm=BOLD
hi CursorLine          ctermfg=NONE  ctermbg=229   cterm=NONE
hi StatusLine          ctermfg=52    ctermbg=253   cterm=NONE
hi StatusLinenc        ctermfg=253   ctermbg=253   cterm=NONE
hi VertSplit           ctermfg=NONE  ctermbg=255   cterm=NONE
hi Folded              ctermfg=NONE  ctermbg=255   cterm=NONE

hi! Directory          ctermfg=232    ctermbg=255   cterm=BOLD

hi TabLine             ctermfg=255   ctermbg=248   cterm=NONE
hi TabLineFill         ctermfg=233   ctermbg=253   cterm=NONE
hi TabLineSel          ctermfg=233   ctermbg=15    cterm=NONE

" hi! DiffAdd            ctermfg=NONE  ctermbg=47
" hi! DiffChange         ctermfg=NONE  ctermbg=11
" hi! DiffDelete         ctermfg=NONE  ctermbg=9
" hi! DiffText           ctermfg=NONE  ctermbg=191

hi! DiffAdd            ctermfg=2     ctermbg=NONE  cterm=NONE
hi! DiffChange         ctermfg=94    ctermbg=NONE  cterm=NONE
hi! DiffDelete         ctermfg=124   ctermbg=NONE  cterm=NONE
hi! DiffText           ctermfg=24    ctermbg=NONE  cterm=BOLD

hi! Pmenu              ctermfg=233   ctermbg=252
hi! PmenuSel           ctermfg=233   ctermbg=248
hi! PmenuThumb         ctermbg=251
hi! link PmenuSbar     Normal

" Gotta watch out for them double operators
syn match doubleOperator "\v\=\="
syn match doubleOperator "\v\.\="
syn match doubleOperator "\v\+\="
syn match doubleOperator "\v\~\="
hi! link doubleOperator Comment


hi! clear SignColumn
hi! link SignColumn Normal

hi! clear Constant
hi! clear Identifier
hi! clear Statement
hi! clear PreProc
hi! clear Type
hi! clear Keyword
hi! clear Special
hi! clear Underlined
hi! clear Ignore
hi! clear Number
hi! clear String
hi! Todo ctermfg=5 ctermbg=NONE cterm=BOLD

hi! NonText ctermfg=bg

hi! link ColorColumn Normal
hi! link Conceal Normal
hi! link Cursor Normal
hi! link CursorIM Normal
hi! link CursorColumn Normal
hi! link FoldColumn Normal
hi! link LineNr Normal
hi! link CursorLineNr Normal
hi! link MatchParen Normal
hi! link ModeMsg Normal
hi! link MoreMsg Normal
hi! link Question Normal
hi! link SpecialKey Normal
hi! link SpellBad Normal
hi! link SpellCap Normal
hi! link SpellLocal Normal
hi! link SpellRare Normal
hi! link VisualNOS Normal
hi! link WildMenu Normal

hi! htmlTag     ctermfg=239 cterm=NONE
hi! htmlTagName ctermfg=239 cterm=NONE
hi! htmlEndTag  ctermfg=239 cterm=NONE
hi! htmlArg     ctermfg=239 cterm=NONE
hi! link xmlTag      htmlTag
hi! link xmlTagName  htmlTag
hi! link xmlEndTag   htmlTag
hi! link xmlArg      htmlTag

hi! link railsMethod Normal
hi! link rubySymbol Normal
