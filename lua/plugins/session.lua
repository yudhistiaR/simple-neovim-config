return {
	{
		"rmagatti/auto-session",
		event = "VimEnter",
		cmd = {
			"SessionSave",
			"SessionRestore",
			"SessionDelete",
			"SessionSearch",
			"AutoSession",
		},
		opts = {
			auto_session_enabled = true,
			auto_save_enabled = true,
			auto_restore_enabled = false,
			auto_session_suppress_dirs = {
				vim.fn.expand("~"),
				vim.fn.expand("~/Downloads"),
				"/",
			},
			bypass_session_save_file_types = {
				"alpha",
				"dashboard",
				"lazy",
				"mason",
				"neo-tree",
				"snacks_dashboard",
				"TelescopePrompt",
			},
			session_lens = {
				load_on_setup = false,
			},
		},
		config = function(_, opts)
			local auto_session = require("auto-session")
			auto_session.setup(opts)

			local function session_cmd(new_cmd, old_cmd)
				if vim.fn.exists(":AutoSession") == 2 then
					pcall(vim.cmd, "silent! " .. new_cmd)
				else
					pcall(vim.cmd, "silent! " .. old_cmd)
				end
			end

			local function git_root_or_cwd()
				local cwd = vim.loop.cwd()
				if not cwd or cwd == "" then
					return vim.fn.getcwd()
				end

				local git_cmd = "git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --show-toplevel"
				local root = vim.fn.systemlist(git_cmd)[1]
				if vim.v.shell_error ~= 0 or not root or root == "" then
					return cwd
				end

				return vim.fn.fnamemodify(root, ":p")
			end

			local function in_project_root(cb)
				local target = git_root_or_cwd()
				local current = vim.fn.getcwd()
				if target ~= current then
					vim.cmd("silent! tcd " .. vim.fn.fnameescape(target))
				end
				cb()
				if target ~= current then
					vim.cmd("silent! tcd " .. vim.fn.fnameescape(current))
				end
			end

			vim.api.nvim_create_user_command("SessionSaveCwd", function()
				in_project_root(function()
					session_cmd("AutoSession save", "SessionSave")
				end)
			end, { desc = "Save session for current project (.git root)" })

			vim.api.nvim_create_user_command("SessionRestoreCwd", function()
				in_project_root(function()
					session_cmd("AutoSession restore", "SessionRestore")
				end)
			end, { desc = "Restore session for current project (.git root)" })

			vim.api.nvim_create_user_command("SessionDeleteCwd", function()
				in_project_root(function()
					session_cmd("AutoSession delete", "SessionDelete")
				end)
			end, { desc = "Delete session for current project (.git root)" })

			vim.api.nvim_create_user_command("SessionListDisabled", function()
				vim.notify("Session list lintas project dinonaktifkan. Gunakan restore per-project (<leader>qr).", vim.log.levels.WARN)
			end, { desc = "Disable cross-project session search" })

			local session_group = vim.api.nvim_create_augroup("SessionAutoSave", { clear = true })

			vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost", "VimSuspend" }, {
				group = session_group,
				desc = "Auto save session on exit / focus lost / suspend",
				callback = function()
					in_project_root(function()
						session_cmd("AutoSession save", "SessionSave")
					end)
				end,
			})
		end,
	},
}
