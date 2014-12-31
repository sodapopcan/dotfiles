hi Normal              ctermfg=232   ctermbg=255   cterm=NONE
hi Visual              ctermfg=NONE  ctermbg=192   cterm=NONE
hi Comment             ctermfg=23    ctermbg=NONE  cterm=NONE
hi Search              ctermfg=NONE  ctermbg=191   cterm=NONE
hi IncSearch           ctermfg=255   ctermbg=24    cterm=NONE
hi WarningMsg          ctermfg=52    ctermbg=NONE  cterm=NONE
hi ErrorMsg            ctermfg=52    ctermbg=NONE  cterm=NONE
hi Function            ctermfg=NONE  ctermbg=NONE  cterm=BOLD
hi CursorLine          ctermfg=NONE  ctermbg=192   cterm=NONE
hi StatusLine          ctermfg=52    ctermbg=250   cterm=NONE
hi StatusLinenc        ctermfg=250   ctermbg=250   cterm=NONE
hi VertSplit           ctermfg=NONE  ctermbg=254   cterm=NONE
hi Folded              ctermfg=NONE  ctermbg=254   cterm=NONE
hi FoldColumn          ctermfg=255   ctermbg=255   cterm=NONE

hi! Directory          ctermfg=24    ctermbg=NONE  cterm=BOLD

hi TabLine             ctermfg=254   ctermbg=248   cterm=NONE
hi TabLineFill         ctermfg=233   ctermbg=248   cterm=NONE
hi TabLineSel          ctermfg=233   ctermbg=253   cterm=NONE

hi! DiffAdd            ctermfg=NONE  ctermbg=22
hi! DiffChange         ctermfg=NONE  ctermbg=3
hi! DiffDelete         ctermfg=NONE  ctermbg=52
hi! DiffText           ctermfg=NONE  ctermbg=13

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
hi! link Special Normal
hi! link Underlined Normal
hi! link Ignore Normal
hi! link Error ErrorMsg
hi! link Number Normal
hi! link String Normal
hi! Todo ctermfg=5 ctermbg=NONE cterm=BOLD

hi! link NonText Normal

hi! link ColorColumn Normal
hi! link Conceal Normal
hi! link Cursor Normal
hi! link CursorIM Normal
hi! link CursorColumn Normal
hi! link LineNr Normal
hi! link CursorLineNr Normal
hi! link MatchParen Normal
hi! link ModeMsg Normal
hi! link MoreMsg Normal
hi! link NonText Normal
hi! link Question Normal
hi! link SpecialKey Normal
hi! link SpellBad Normal
hi! link SpellCap Normal
hi! link SpellLocal Normal
hi! link SpellRare Normal
hi! link VisualNOS Normal
hi! link WildMenu Normal

hi! htmlTag     ctermfg=58 cterm=BOLD
hi! htmlTagName ctermfg=58 cterm=BOLD
hi! htmlEndTag  ctermfg=58 cterm=BOLD
hi! htmlArg     ctermfg=58 cterm=BOLD
hi! link xmlTag      htmlTag
hi! link xmlTagName  htmlTag
hi! link xmlEndTag   htmlTag
hi! link xmlArg      htmlTag

hi! link railsMethod Normal
hi! link rubySymbol Normal
