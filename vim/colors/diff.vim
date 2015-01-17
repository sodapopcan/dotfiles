" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "diff"

hi Normal              ctermfg=240   ctermbg=236   cterm=NONE
hi Visual              ctermfg=NONE  ctermbg=192   cterm=NONE
hi Comment             ctermfg=235   ctermbg=NONE  cterm=NONE
hi Search              ctermfg=NONE  ctermbg=191   cterm=NONE
hi IncSearch           ctermfg=255   ctermbg=24    cterm=NONE
hi WarningMsg          ctermfg=52    ctermbg=NONE  cterm=NONE
hi ErrorMsg            ctermfg=255   ctermbg=124   cterm=NONE
hi link Function Normal
hi CursorLine          ctermfg=NONE  ctermbg=235   cterm=NONE
hi VertSplit                 ctermfg=235   ctermbg=bg    cterm=none
hi! link Folded Normal

hi! Directory          ctermfg=232    ctermbg=255   cterm=BOLD

hi TabLine             ctermfg=fg    ctermbg=238   cterm=NONE
hi TabLineFill         ctermfg=fg    ctermbg=238   cterm=NONE
hi TabLineSel          ctermfg=15    ctermbg=bg    cterm=BOLD

hi StatusLine          ctermfg=52    ctermbg=238   cterm=NONE
hi StatusLineNC        ctermfg=238   ctermbg=238   cterm=NONE

" Gitv
hi! diffAdded                 ctermfg=107    ctermbg=NONE
hi! diffRemoved               ctermfg=95     ctermbg=NONE
hi! diffLine                  ctermfg=118    ctermbg=NONE
hi! diffSubname               ctermfg=113    ctermbg=NONE

hi! DiffAdd                   ctermfg=107   ctermbg=NONE cterm=NONE
hi! DiffDelete                ctermfg=95    ctermbg=NONE cterm=NONE
hi! DiffChange                ctermfg=152   ctermbg=NONE cterm=NONE
hi! DiffText                  ctermfg=144   ctermbg=NONE cterm=NONE

hi! Pmenu              ctermfg=242   ctermbg=254  cterm=NONE
hi! PmenuSel           ctermfg=255   ctermbg=240  cterm=BOLD
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
