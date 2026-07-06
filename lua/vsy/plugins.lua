-- ════════════════════════════════════════════════════════════
-- Bootstrap lazy.nvim (plugin manager)
-- ════════════════════════════════════════════════════════════
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- suppress deprecations
vim.deprecate = function() end

require("lazy").setup({
	-- ══════════════════════════════════════════════════════════
	-- Editing & Motions
	-- ══════════════════════════════════════════════════════════
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	},

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- highlight jump targets for f/F/t/T
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
				dim = true,
			})
		end,
	},

	-- ══════════════════════════════════════════════════════════
	-- Finder & Project
	-- ══════════════════════════════════════════════════════════
	-- UI to select things (files, grep results, open buffers...)
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		-- or, branch = '0.1.x',
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{
		"DrKJeff16/project.nvim",
		config = function() end,
		dependencies = { -- OPTIONAL. Choose any of the following
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			"wsdjeg/picker.nvim",
			"folke/snacks.nvim",
			"ibhagwan/fzf-lua",
		},
		opts = {},
	},

	-- ══════════════════════════════════════════════════════════
	-- Keymap Helper (which-key style)
	-- ══════════════════════════════════════════════════════════
	"cetanu/key-menu.nvim",

	-- ══════════════════════════════════════════════════════════
	-- Git
	-- ══════════════════════════════════════════════════════════
	{
		"TimUntersberger/neogit",
		config = function()
			require("neogit").setup({
				integrations = {
					telescope = true,
					diffview = true,
				},
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
	},
	-- change signs in the gutter + hunk operations
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- ══════════════════════════════════════════════════════════
	-- Treesitter (syntax & textobjects)
	-- ══════════════════════════════════════════════════════════
	-- main branch — required for neovim 0.11+/0.12
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("vsy.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
	},

	-- ══════════════════════════════════════════════════════════
	-- Completion & Snippets
	-- ══════════════════════════════════════════════════════════
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = { preset = "enter" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.4.1",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
		build = "make install_jsregexp",
	},

	-- ══════════════════════════════════════════════════════════
	-- LSP & Language Support
	-- ══════════════════════════════════════════════════════════
	"neovim/nvim-lspconfig",
	-- lua LSP: injects nvim/vim API types when editing this config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- language server installer
	{ "mason-org/mason.nvim", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"yamlls",
				"jsonls",
				"rust_analyzer",
				"ts_ls",
				"gopls",
				"dockerls",
				"bashls",
				"jdtls",
				"kotlin_language_server",
			},
			automatic_enable = false,
		},
	},
	-- filetype / syntax support
	{ "cespare/vim-toml", branch = "main" },
	"towolf/vim-helm",
	-- auto-close brackets / quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{ -- language-specific tooling: Rust
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({})
		end,
		dependencies = { "neovim/nvim-lspconfig" },
	},

	-- ── LSP UI & diagnostics ──────────────────────────────────
	{ -- LSP progress spinner
		"j-hui/fidget.nvim",
		branch = "legacy",
	},
	"onsails/lspkind-nvim", -- completion-menu icons
	{ -- diagnostics list panel
		"folke/trouble.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({})
		end,
	},
	{ -- auto-refreshing docs view
		"amrbashir/nvim-docs-view",
		opt = true,
		cmd = { "DocsViewToggle" },
		config = function()
			require("docs-view").setup({
				position = "bottom",
			})
		end,
	},
	{ -- code outline / symbol navigation
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup()
		end,
	},
	"jubnzv/virtual-types.nvim", -- inline inferred types

	-- ══════════════════════════════════════════════════════════
	-- Theme
	-- ══════════════════════════════════════════════════════════
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme kanagawa")
	-- 	end,
	-- },
	-- {
	-- 	"sainnhe/edge",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme edge")
	-- 	end,
	-- },

	-- {
	-- 	"vague-theme/vague.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme vague")
	-- 	end,
	-- },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.g.gruvbox_material_background = "hard"
	-- 		vim.g.gruvbox_material_foreground = "original"
	-- 		vim.g.gruvbox_material_better_performance = 1
	-- 		vim.cmd("colorscheme gruvbox-material")
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({ style = "night" })
			vim.cmd("colorscheme tokyonight")
		end,
	},
	--
	-- {
	-- 	"srcery-colors/srcery-vim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd("colorscheme srcery")
	-- 	end,
	-- },

	-- ══════════════════════════════════════════════════════════
	-- UI / Editing UX
	-- ══════════════════════════════════════════════════════════
	"tjdevries/express_line.nvim", -- statusline
	{ "nanozuki/tabby.nvim" }, -- tabline
	{ -- edit the filesystem as a buffer
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	},
	{ -- prettier vim.ui.select / input
		"stevearc/dressing.nvim",
		config = function()
			require("dressing").setup()
		end,
	},
	{ -- replaces messages / cmdline / popupmenu UI
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- "rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	},
	{ -- highlight hex colors inline
		"norcalli/nvim-colorizer.lua",
		lazy = true,
		config = function()
			require("colorizer").setup()
		end,
	},
	{ -- indentation guides (│ at every indent level)
		"saghen/blink.indent",
		config = function()
			require("blink.indent").setup({
				static = { enabled = true, char = "│" },
				scope = { enabled = true, char = "│" },
			})
		end,
	},
	{ -- nicer quickfix window
		"stevearc/quicker.nvim",
		ft = "qf",
		config = function()
			require("quicker").setup()
		end,
	},

	-- ══════════════════════════════════════════════════════════
	-- Formatting
	-- ══════════════════════════════════════════════════════════
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = {
						"ruff_fix",
						"ruff_format",
						"ruff_organize_imports",
					},
					-- Use a sub-list to run only the first available formatter
					-- javascript = { { "prettierd", "prettier" } },
				},
				formatters = {
					ruff_format = {
						command = "ruff",
						args = { "format", "--stdin-filename", "$FILENAME", "-" },
						stdin = true,
					},
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = false,
				},
			})
		end,
	},

	-- ══════════════════════════════════════════════════════════
	-- Security (secret masking)
	-- ══════════════════════════════════════════════════════════
	{
		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup({
				enabled = true,
				cloak_character = "*",
				patterns = {
					{
						file_pattern = "*",
						cloak_pattern = {
							-- Redact JWTs
							"eyJ[A-Za-z0-9-_=]+.eyJ[A-Za-z0-9-_=]+.[A-Za-z0-9-_.+/=]+",
							-- Redact API tokens
							"ghp_[0-9a-zA-Z]{36}",
							"gho_[0-9a-zA-Z]{36}",
							"ghu_[0-9a-zA-Z]{36}",
							"ghs_[0-9a-zA-Z]{36}",
							"ghr_[0-9a-zA-Z]{36}",
							-- Redact cryptocurrency addresses
							"^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$",
							"^0x[a-fA-F0-9]{40}$",
							-- Redact seed phrases
							"([a-z]+ ){11,23}[a-z]+",
						},
					},
					{
						-- Key-based secrets: reveal only the first character of the value
						file_pattern = { "*.yaml", "*.yml", "*.properties", "*.json", "*.env", "*.conf", "*.tpl", "*.toml" },
						cloak_pattern = {
							"(.-[Pp]assword[%w_]*%s*[:=]%s*.).+",
							"(.-[Pp]asswd[%w_]*%s*[:=]%s*.).+",
							"(.-[Ss]ecret[%w_]*%s*[:=]%s*.).+",
							"(.-[Tt]oken[%w_]*%s*[:=]%s*.).+",
							"(.-[Aa]pi[_]?[Kk]ey[%w_]*%s*[:=]%s*.).+",
							"(.-[Aa]ccess[_]?[Kk]ey[%w_]*%s*[:=]%s*.).+",
							"(.-[Pp]rivate[_]?[Kk]ey[%w_]*%s*[:=]%s*.).+",
							"(.-[Ee]ncrypt[%w_]*%s*[:=]%s*.).+",
							"(.-[Cc]redential[%w_]*%s*[:=]%s*.).+",
						},
						replace = "%1",
					},
				},
			})
		end,
	},

	-- ══════════════════════════════════════════════════════════
	-- AI auto-complete
	-- ══════════════════════════════════════════════════════════
	-- {
	-- 	"supermaven-inc/supermaven-nvim",
	-- 	config = function()
	-- 		require("supermaven-nvim").setup({})
	-- 	end,
	-- },

	-- ══════════════════════════════════════════════════════════
	-- Custom plugins (cetanu)
	-- ══════════════════════════════════════════════════════════
	{ "cetanu/taskrunner.nvim" },
	{ "cetanu/python-env.nvim" },
	{
		"cetanu/recent-work.nvim",
		config = function()
			require("recent-work").setup({
				project_directory = vim.fn.expand("~/Documents"),
				days_back = 7,
				max_depth = 2,
			})
		end,
	},
})
