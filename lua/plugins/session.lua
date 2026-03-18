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
		keys = {
			{ "<leader>qs", "<cmd>AutoSession save<cr>", desc = "Session save" },
			{ "<leader>qr", "<cmd>AutoSession restore<cr>", desc = "Session restore" },
			{ "<leader>qd", "<cmd>AutoSession delete<cr>", desc = "Session delete" },
			{ "<leader>ql", "<cmd>AutoSession search<cr>", desc = "Session list (current project)" },
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
				cwd_only = true,
			},
		},
		config = function(_, opts)
			local auto_session = require("auto-session")
			auto_session.setup(opts)

			local function git_root_from_cwd()
				local git_dir = vim.fs.find(".git", { upward = true, path = vim.fn.getcwd() })[1]
				if not git_dir then
					return nil
				end
				return vim.fs.dirname(git_dir)
			end

			vim.api.nvim_create_autocmd("VimEnter", {
				desc = "Normalize cwd to git root for project-scoped sessions",
				callback = function()
					local root = git_root_from_cwd()
					if root and root ~= vim.fn.getcwd() then
						vim.api.nvim_set_current_dir(root)
					end
				end,
			})

			local session_group = vim.api.nvim_create_augroup("SessionAutoSave", { clear = true })

			vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost", "VimSuspend" }, {
				group = session_group,
				desc = "Auto save session on exit / focus lost / suspend",
				callback = function()
					if vim.fn.exists(":AutoSession") == 2 then
						pcall(vim.cmd, "silent! AutoSession save")
					else
						pcall(vim.cmd, "silent! SessionSave")
					end
				end,
			})
		end,
	},
}
