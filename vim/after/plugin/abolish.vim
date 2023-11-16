let g:abolish_save_file = expand('<sfile>')

if !exists(':Abolish')
  finish
endif

Abolish absolish{,es}                    abolish{,es}
Abolish damange{,s}                      damange{,s}
Abolish destory{,s}                      destroy{,s}
Abolish inculde{,s}                      include{,s}
Abolish yeild{,s}                        yield{,s}
Abolish for{e}cas{e,t}{,s}               for{e}cas{t}{,s}
Abolish artowrk{,s}                      artwork{,s}
Abolish artowkr{,s}                      artwork{,s}






iab sa= socket =<CR>socket<CR>\|> assign()<Left>
iab defm @impl true<CR>def mount(_params, _session, socket) do<CR><CR>{:ok, socket}<CR>end<CR><Esc><up>==<up><up>O
iab defr def render(assigns) do<CR>~H"""<CR>
iab defe def handle_event(_event, _params, socket) do<CR>{:noreply, socket}<CR>end<Esc><up><up>wwwcaw""<left>
" ab defrw def render(assigns) when do<CR>~H"""<CR><Up>
