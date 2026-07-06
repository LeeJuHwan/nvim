-- Y yank until the end of line  (note: this is now a default on master)
vim.keymap.set("n", "Y", "y$", { noremap = true })
-- Re-center on next term
vim.keymap.set("n", "n", "nzz", { noremap = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true })

local function cmd(text, lua)
	if lua then
		return ":lua " .. text .. "<CR>"
	else
		return "<Cmd>" .. text .. "<CR>"
	end
end

local function key_binding(key, command, description, mode, lua)
	if mode == nil then
		mode = "n"
	end
	vim.keymap.set(mode, "<leader>" .. key, cmd(command, lua), { desc = description })
end

local key_menu = require("key-menu")
key_menu.set("n", "<Space>")

-- Fundamentals
key_binding("n", "noh", "Clear highlights")
key_binding("q", "wqa", "Quit")
key_binding("Q", "qa!", "Quit without saving")

-- Git
--key_binding("g", "Neogit kind=floating", "Neogit")
key_binding("g", "Neogit", "Neogit")

-- Git hunks (gitsigns)
local gs = "require('gitsigns')"
-- <Space>h : show change inline, in place, without a diff view (main)
key_binding("h", gs .. ".preview_hunk_inline()", "Preview hunk (inline)", nil, true)
-- <Space>H… : other hunk operations
key_menu.set("n", "<Space>H", { desc = "Git hunks" })
key_binding("Hp", gs .. ".preview_hunk()", "Preview hunk (popup)", nil, true)
key_binding("Hn", gs .. ".nav_hunk('next')", "Next hunk", nil, true)
key_binding("HN", gs .. ".nav_hunk('prev')", "Prev hunk", nil, true)
key_binding("Hs", gs .. ".stage_hunk()", "Stage hunk", nil, true)
key_binding("Hr", gs .. ".reset_hunk()", "Reset hunk", nil, true)
key_binding("Hu", gs .. ".undo_stage_hunk()", "Undo stage hunk", nil, true)
key_binding("Hd", gs .. ".toggle_deleted()", "Toggle deleted lines", nil, true)
key_binding("Hb", gs .. ".blame_line({ full = true })", "Blame line", nil, true)

-- LSP bindings
key_menu.set("n", "<Space>l", { desc = "LSP" })
key_binding("lr", "vim.lsp.buf.rename()", "Rename", nil, true)
key_binding("lR", "vim.lsp.buf.references()", "Find References", nil, true)
key_binding("ld", "vim.lsp.buf.definition()", "Go to Definition", nil, true)
key_binding("la", "vim.lsp.buf.code_action()", "Code Action", nil, true)
key_binding("le", "vim.lsp.diagnostic.get_line_diagnostics()", "Diagnostics", nil, true)

-- Telescope
key_menu.set("n", "<Space>t", { desc = "Telescope" })
key_binding("tf", "Telescope find_files", "Find Files")
key_binding("tg", "Telescope live_grep", "Grep")
key_binding("tp", "Telescope projects", "Switch project")
key_binding("tS", "require('telescope.builtin').live_grep({cwd = '~/Documents'})", "Search all projects", nil, true)
key_binding("td", "Telescope diagnostics", "Diagnostics")
key_binding("tr", "Telescope oldfiles", "Recent files")
key_binding("tb", "Telescope buffers", "Open buffers")
key_binding("tc", "Telescope command_history", "Command History")

-- Trouble
key_binding("Td", "Trouble diagnostics", "Diagnostics")
key_binding("Tt", "Trouble todo", "TO-DO comments")

-- Aerial
key_binding("a", "AerialOpen", "Aerial menu")

-- Oil
key_binding("o", "Oil", "Edit files (oil)")

-- Tasks
key_binding("rt", "TaskRunner", "Run task")

-- Recent work
key_binding("rw", "RecentWorkMyCommits", "Recent work")

-- Tabs
-- vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
key_binding("tta", ":$tabnew<CR>", "New Tab")

-- Cloak (secret masking)
key_binding("tc", "CloakToggle", "Cloak toggle")
key_binding("tl", "CloakPreviewLine", "Cloak preview line")

-- LuaSnip
key_menu.set("n", "<Space>s", { desc = "Snippets" })
key_binding("sr", "source ~/.config/nvim/after/plugin/luasnip.lua", "Reload")
