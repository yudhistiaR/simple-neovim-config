return {
	{
		"rmagatti/auto-session",
		event = "VimEnter",
		cmd = {
			"SessionSave",
			"SessionRestore",
			"SessionDelete",
			"SessionSearch",
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
	},
}
