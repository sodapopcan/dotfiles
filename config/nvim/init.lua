-- vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
-- vim.cmd("let &packpath = &runtimepath")
-- vim.cmd("source ~/.vimrc")
-- require("elixir").setup()
-- require("elixir").setup()
-- require('nvim-treesitter.configs').setup {
--     endwise = {
--         enable = true,
--     },
--   }

-- require'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all" (the five listed parsers should always be installed)
--   ensure_installed = { "markdown", "diff", "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "eex", "html", "ruby", "javascript", "typescript" },

--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,

--   -- Automatically install missing parsers when entering buffer
--   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--   auto_install = true,

--   -- List of parsers to ignore installing (or "all")
--   ignore_install = { "javascript" },

--   ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
--   -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

--   indent = { enable = true },

--   highlight = {
--     enable = true,

--     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
--     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
--     -- the name of the parser)
--     -- list of language that will be disabled
--     disable = { },
--     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
--     disable = function(lang, buf)
--         local max_filesize = 100 * 1024 -- 100 KB
--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--         if ok and stats and stats.size > max_filesize then
--             return true
--         end
--     end,

--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },

--   layout_config = {
--     border = {}
--   }
-- }

-- require'telescope'.setup {
--   defaults = {
--     dynamic_preview_title = false,
--     results_title = false,
--     file_ignore_patterns = {
--       "assets/vendor/heroicons",
--       "priv/static/images",
--       "deps",
--       "_build"
--     },
--     mappings = {
--       i = {
--         ["<esc>"] = require('telescope.actions').close,
--       }
--     }
--   },
-- }

-- vim.api.nvim_set_hl(0, "@symbol", { link = "Identifier" })
-- vim.api.nvim_set_hl(0, "@variable", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "@function.call", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "@string.special", { link = "String" })
-- vim.api.nvim_set_hl(0, "@punctuation.delimiter.heex", { link = "Keyword" })
-- vim.api.nvim_set_hl(0, "@function.heex", { link = "Function" })
-- vim.api.nvim_set_hl(0, "@tag.heex", { link = "Function" })
-- vim.api.nvim_set_hl(0, "@tag.delimiter.heex", { link = "Function" })
-- vim.api.nvim_set_hl(0, "@tag.attribute.heex", { link = "Special" })
-- vim.api.nvim_set_hl(0, "@parameter.ruby", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "@punctuation", { link = "Normal" })
-- vim.cmd("nnoremap zS :Inspect<cr>")
