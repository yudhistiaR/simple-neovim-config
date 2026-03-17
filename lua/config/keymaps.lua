local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =========================
-- Basic
-- =========================
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- =========================
-- Explorer / Search
-- =========================
keymap("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", { desc = "Explorer" })
keymap("n", "<leader>o", "<cmd>Neotree focus filesystem left<cr>", { desc = "Focus explorer" })
keymap("n", "<leader>bf", "<cmd>Neotree toggle buffers right<cr>", { desc = "Buffers" })
keymap("n", "<leader>gs", "<cmd>Neotree toggle git_status right<cr>", { desc = "Git status" })

keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Search buffers" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>qs", "<cmd>SessionSaveCwd<cr>", { desc = "Session save" })
keymap("n", "<leader>qr", "<cmd>SessionRestoreCwd<cr>", { desc = "Session restore" })
keymap("n", "<leader>qd", "<cmd>SessionDeleteCwd<cr>", { desc = "Session delete" })
keymap("n", "<leader>ql", "<cmd>SessionListDisabled<cr>", { desc = "Session list (disabled cross-project)" })

-- =========================
-- Clipboard / Register safe edits
-- =========================
keymap("n", "x", '"_x', { desc = "Delete char without yanking" })

keymap("n", "<leader>p", '"0p', { desc = "Paste last yanked" })
keymap("n", "<leader>P", '"0P', { desc = "Paste before last yanked" })
keymap("v", "<leader>p", '"0p', { desc = "Paste in visual last yanked" })

keymap("n", "<leader>c", '"_c', { desc = "Change without yanking" })
keymap("n", "<leader>C", '"_C', { desc = "Change line without yanking" })
keymap("v", "<leader>c", '"_c', { desc = "Change selection without yanking" })
keymap("v", "<leader>C", '"_C', { desc = "Change selection line without yanking" })

keymap("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
keymap("n", "<leader>D", '"_D', { desc = "Delete line without yanking" })
keymap("v", "<leader>d", '"_d', { desc = "Delete selection without yanking" })
keymap("v", "<leader>D", '"_D', { desc = "Delete selection line without yanking" })

-- =========================
-- Editing helpers
-- =========================
keymap("n", "+", "<C-a>", { desc = "Increment number" })
keymap("n", "-", "<C-x>", { desc = "Decrement number" })
keymap("n", "dw", 'vb"_d', { desc = "Delete previous word" })
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Disable comment continuation on new line
keymap("n", "<leader>nl", "o<Esc>^Da", { desc = "New line below without comment" })
keymap("n", "<leader>nL", "O<Esc>^Da", { desc = "New line above without comment" })

-- =========================
-- Terminal toggle
-- =========================
local terminal_buf = nil
local terminal_win = nil

local function toggle_terminal()
	if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
		vim.api.nvim_win_close(terminal_win, true)
		terminal_win = nil
		return
	end

	vim.cmd("botright 12split")

	if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
		vim.api.nvim_win_set_buf(0, terminal_buf)
	else
		vim.cmd("terminal")
		terminal_buf = vim.api.nvim_get_current_buf()
	end

	terminal_win = vim.api.nvim_get_current_win()
	vim.cmd("startinsert")
end

keymap({ "n", "i", "t" }, "<C-_>", function()
	if vim.api.nvim_get_mode().mode == "t" then
		vim.cmd("stopinsert")
	end
	toggle_terminal()
end, { desc = "Toggle terminal" })

keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- =========================
-- Search
-- =========================
keymap("n", "//", "<cmd>Telescope live_grep<cr>", { desc = "Search text in project" })

-- =========================
-- Tabs
-- =========================
keymap("n", "te", ":tabedit<Return>", opts)
keymap("n", "<tab>", ":tabnext<Return>", opts)
keymap("n", "<S-tab>", ":tabprev<Return>", opts)

-- =========================
-- Splits
-- =========================
keymap("n", "ss", ":split<Return>", opts)
keymap("n", "sv", ":vsplit<Return>", opts)

keymap("n", "sh", "<C-w>h", { desc = "Move to left split" })
keymap("n", "sj", "<C-w>j", { desc = "Move to lower split" })
keymap("n", "sk", "<C-w>k", { desc = "Move to upper split" })
keymap("n", "sl", "<C-w>l", { desc = "Move to right split" })

keymap("n", "<C-w><Left>", "<C-w><", { desc = "Resize split left" })
keymap("n", "<C-w><Right>", "<C-w>>", { desc = "Resize split right" })
keymap("n", "<C-w><Up>", "<C-w>+", { desc = "Resize split up" })
keymap("n", "<C-w><Down>", "<C-w>-", { desc = "Resize split down" })

-- =========================
-- Diagnostics / LSP
-- =========================
keymap("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

keymap("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
keymap("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })

-- Inlay hints toggle (Neovim 0.10+ / 0.11+)
keymap("n", "<leader>ti", function()
	local enabled = vim.lsp.inlay_hint.is_enabled({})
	vim.lsp.inlay_hint.enable(not enabled)
end, { desc = "Toggle inlay hints" })

-- =========================
-- User commands
-- =========================
vim.api.nvim_create_user_command("ToggleAutoformat", function()
	vim.g.autoformat = not vim.g.autoformat
	if vim.g.autoformat then
		print("Autoformat: ON")
	else
		print("Autoformat: OFF")
	end
end, {})

-- default on
vim.g.autoformat = true
