-- ════════════════════════════════════════════════════════════
-- Leader (must be set before plugins/keymaps load)
-- ════════════════════════════════════════════════════════════
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ════════════════════════════════════════════════════════════
-- Files & undo
-- ════════════════════════════════════════════════════════════
vim.opt.undofile = true
vim.opt.undodir = vim.env.HOME .. "/.vim/undodir"
vim.opt.backup = false
vim.opt.swapfile = false

-- ════════════════════════════════════════════════════════════
-- Search
-- ════════════════════════════════════════════════════════════
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ════════════════════════════════════════════════════════════
-- UI
-- ════════════════════════════════════════════════════════════
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.errorbells = false
vim.opt.cmdheight = 2
vim.opt.pumheight = 10 -- max completion popup height
vim.opt.confirm = true -- prompt to save instead of failing
vim.opt.encoding = "UTF-8"
vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
}

-- ════════════════════════════════════════════════════════════
-- Indentation (defaults; per-filetype overrides below)
-- ════════════════════════════════════════════════════════════
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.backspace = { "indent", "eol", "start" }

-- ════════════════════════════════════════════════════════════
-- Timing
-- ════════════════════════════════════════════════════════════
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300

-- ════════════════════════════════════════════════════════════
-- Clipboard (yank goes to the system clipboard)
-- ════════════════════════════════════════════════════════════
vim.opt.clipboard = "unnamedplus"

-- ════════════════════════════════════════════════════════════
-- Autocommands
-- ════════════════════════════════════════════════════════════
-- Highlight yanked text briefly
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

-- YAML / Helm use 2-space indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "yaml", "helm" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

-- Restore last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- ════════════════════════════════════════════════════════════
-- Misc plugin globals
-- ════════════════════════════════════════════════════════════
-- indent-blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Disable ocaml from hijacking keymaps
vim.g.no_ocaml_maps = true
