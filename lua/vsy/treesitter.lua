-- nvim-treesitter MAIN branch configuration (required for neovim 0.11+/0.12).
--
-- The `master` branch is archived; its queries reference node types
-- (e.g. python `except*`, kotlin `!is`) that break on neovim 0.12's stricter
-- query loader, causing "Invalid node type" errors when opening those files.
-- The `main` branch delegates highlight/indent to the user, done below.

local parsers = {
	"bash",
	"css",
	"fish",
	"go",
	"html",
	"javascript",
	"json",
	"lua",
	"make",
	"proto",
	"python",
	"rst",
	"rust",
	"toml",
	"yaml",
	"kotlin",
	"markdown",
}

-- Install / update parsers (async, main-branch API).
pcall(function()
	require("nvim-treesitter").install(parsers)
end)

-- Enable treesitter highlighting (+ indentation) per buffer.
-- On the main branch this is the user's responsibility, not the plugin's.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("vsy_treesitter", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if lang and pcall(vim.treesitter.start, args.buf, lang) then
			-- Treesitter-based indentation (main branch provides indentexpr()).
			if type(require("nvim-treesitter").indentexpr) == "function" then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end,
})

-- Textobjects (main-branch API uses explicit keymaps instead of a config table).
pcall(function()
	require("nvim-treesitter-textobjects").setup({})
	local select = require("nvim-treesitter-textobjects.select")
	local move = require("nvim-treesitter-textobjects.move")

	local function tmap(mode, lhs, fn)
		vim.keymap.set(mode, lhs, fn, { silent = true })
	end

	tmap({ "x", "o" }, "af", function()
		select.select_textobject("@function.outer", "textobjects")
	end)
	tmap({ "x", "o" }, "if", function()
		select.select_textobject("@function.inner", "textobjects")
	end)
	tmap({ "x", "o" }, "ac", function()
		select.select_textobject("@class.outer", "textobjects")
	end)
	tmap({ "x", "o" }, "ic", function()
		select.select_textobject("@class.inner", "textobjects")
	end)

	tmap({ "n", "x", "o" }, "]m", function()
		move.goto_next_start("@function.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "]]", function()
		move.goto_next_start("@class.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "]M", function()
		move.goto_next_end("@function.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "][", function()
		move.goto_next_end("@class.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "[m", function()
		move.goto_previous_start("@function.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "[[", function()
		move.goto_previous_start("@class.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "[M", function()
		move.goto_previous_end("@function.outer", "textobjects")
	end)
	tmap({ "n", "x", "o" }, "[]", function()
		move.goto_previous_end("@class.outer", "textobjects")
	end)
end)
