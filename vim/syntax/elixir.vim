call matchadd("elixirFunctionSpec", '^\s\+@spec \_.\{-}\zedef')
call matchadd("elixirDocString", '^\s\+@\(doc\|moduledoc\) """\_.\{-}\s\+"""')
call matchadd("elixirImpl", '\s\+@impl.*')
