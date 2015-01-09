" This is based on Nick Moffitt's version of Josh O'Rourke's version of
" railscasts.vim.  I've tweaked it and removed all the GUI noise.

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sodapopcan"

hi link htmlTag              xmlTag
hi link htmlTagName          xmlTagName
hi link htmlEndTag           xmlEndTag

hi Normal                    ctermfg=137   ctermbg=236
hi Cursor                    ctermfg=0     ctermbg=15
hi CursorLine                ctermfg=NONE  ctermbg=NONE  cterm=NONE
hi CursorCol                 ctermfg=NONE
hi TabLine                   ctermfg=254   ctermbg=238   cterm=NONE
hi TabLineFill               ctermfg=254   ctermbg=bg    cterm=NONE
hi TabLineSel                ctermfg=242   ctermbg=bg    cterm=NONE

hi StatusLine                ctermfg=52    ctermbg=238   cterm=NONE
hi StatusLineNC              ctermfg=238   ctermbg=238   cterm=NONE
hi VertSplit                 ctermfg=bg    ctermbg=235   cterm=none

hi Comment                   ctermfg=137
hi Constant                  ctermfg=73
hi link Identifier Constant
hi Define                    ctermfg=173   cterm=NONE
hi Statement                 ctermfg=173   cterm=NONE
hi Error                     ctermfg=221   ctermbg=88
hi Function                  ctermfg=173   cterm=BOLD
hi Keyword                   ctermfg=173   cterm=NONE
hi link Include              Statement
hi link PreCondit            Statement

hi LineNr                    ctermfg=243   ctermbg=235
hi CursorLineNr              ctermfg=250   ctermbg=234 cterm=NONE
hi String                    ctermfg=107
hi link Number String
hi PreProc                   ctermfg=103
hi Search                    ctermfg=16    ctermbg=186
hi IncSearch                 ctermfg=16    ctermbg=186
hi Title                     ctermfg=15
hi Type                      ctermfg=167   cterm=NONE
hi Visual                    ctermbg=60

hi link diffAdded            String
hi link diffRemoved          Type
hi link diffLine             PreProc
hi link diffSubname          Comment

hi DiffAdd                   ctermfg=2     ctermbg=bg
hi DiffDelete                ctermfg=9     ctermbg=bg
hi DiffChange                ctermfg=6     ctermbg=bg
hi DiffText                  ctermfg=12    ctermbg=bg  cterm=bold
hi Special                   ctermfg=167   ctermbg=bg  cterm=NONE

hi pythonBuiltin             ctermfg=73 cterm=NONE
hi rubyBlockParameter        ctermfg=43
hi link rubyConstant           Type
hi link rubyPredefinedConstant Type
hi rubyInstanceVariable      ctermfg=132
hi rubyInterpolation         ctermfg=107
hi rubyLocalVariableOrMethod ctermfg=189
hi rubyPseudoVariable        ctermfg=221
hi link rubyStringDelimiter  String

hi NonText                   ctermfg=8
hi SpecialKey                ctermfg=8

hi xmlTag                    ctermfg=179
hi xmlTagName                ctermfg=179
hi xmlEndTag                 ctermfg=179

hi mailSubject               ctermfg=107
hi mailHeaderKey             ctermfg=221
hi mailEmail                 ctermfg=107 cterm=underline

hi SpellBad                  ctermfg=160 ctermbg=NONE cterm=underline
hi SpellRare                 ctermfg=168 ctermbg=NONE cterm=underline
hi SpellCap                  ctermfg=189 ctermbg=NONE cterm=underline
hi MatchParen                ctermfg=15 ctermbg=23

hi Ignore                    ctermfg=Black
hi WildMenu                  cterm=bold
hi Directory                 none
hi link Directory            Identifier

hi Folded                    ctermbg=238 ctermfg=White cterm=NONE
hi FoldColumn                none
hi link FoldColumn           Folded

hi Pmenu                     ctermbg=238 ctermfg=White cterm=NONE
hi PmenuSel                  ctermbg=150 ctermfg=Black
hi PMenuSbar                 cterm=NONE
hi PMenuThumb                cterm=NONE

hi SignColumn ctermbg=bg
