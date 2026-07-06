-- ════════════════════════════════════════════════════════════
-- Enabled language servers
-- ════════════════════════════════════════════════════════════
local servers = {
	"rust_analyzer",
	"ts_ls",
	"yamlls",
	"jsonls",
	"gopls",
	"dockerls",
	"bashls",
	"basedpyright",
	-- "ty",
	-- "ruff",
	"jdtls",
	"kotlin_language_server",
}

for _, server in pairs(servers) do
	vim.lsp.enable(server)
end

-- ════════════════════════════════════════════════════════════
-- Diagnostics display
-- ════════════════════════════════════════════════════════════
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = { current_line = true },
	severity_sort = true,
	float = { border = "rounded" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})

-- ════════════════════════════════════════════════════════════
-- LSP progress UI
-- ════════════════════════════════════════════════════════════
require("fidget").setup({})
