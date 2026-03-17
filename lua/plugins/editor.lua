return {
	{
		"folke/flash.nvim",
		enabled = false,
		opts = {
			search = {
				forward = true,
				multi_window = false,
				wrap = false,
				incremental = true,
			},
		},
	},

	{
		"nvim-mini/mini.hipatterns",
		version = false,
		event = "BufReadPost",
		config = function()
			local hipatterns = require("mini.hipatterns")

			hipatterns.setup({
				highlighters = {
					fixme = {
						pattern = "%f[%w]()FIXME()%f[%W]",
						group = "MiniHipatternsFixme",
					},
					hack = {
						pattern = "%f[%w]()HACK()%f[%W]",
						group = "MiniHipatternsHack",
					},
					todo = {
						pattern = "%f[%w]()TODO()%f[%W]",
						group = "MiniHipatternsTodo",
					},
					note = {
						pattern = "%f[%w]()NOTE()%f[%W]",
						group = "MiniHipatternsNote",
					},
					bug = {
						pattern = "%f[%w]()BUG()%f[%W]",
						group = "DiagnosticError",
					},
					perf = {
						pattern = "%f[%w]()PERF()%f[%W]",
						group = "DiagnosticWarn",
					},

					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},

	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_hex = true,
			enable_short_hex = true,
			enable_rgb = true,
			enable_hsl = true,
			enable_hsl_without_function = true,
			enable_ansi = true,
			enable_var_usage = true,
			enable_tailwind = true,
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				blame = "<leader>gb",
				browse = "<leader>go",
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				";f",
				function()
					require("telescope.builtin").find_files({
						hidden = true,
					})
				end,
				desc = "Find files",
			},
			{
				";r",
				function()
					require("telescope.builtin").live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Live grep",
			},
			{
				"\\\\",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				";t",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help tags",
			},
			{
				";;",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume telescope",
			},
			{
				";e",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				";s",
				function()
					require("telescope.builtin").treesitter()
				end,
				desc = "Treesitter symbols",
			},
			{
				";c",
				function()
					require("telescope.builtin").lsp_incoming_calls()
				end,
				desc = "LSP incoming calls",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")

					local function current_buffer_dir()
						return vim.fn.expand("%:p:h")
					end

					telescope.extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = current_buffer_dir(),
						respect_gitignore = true,
						hidden = true,
						grouped = true,
						previewer = false,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "File browser",
			},
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fn.stdpath("config"),
					})
				end,
				desc = "Find config file",
			},
		},
		opts = function(_, opts)
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {},
				},
			})

			opts.pickers = vim.tbl_deep_extend("force", opts.pickers or {}, {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
				find_files = {
					hidden = true,
				},
			})

			opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
				file_browser = {
					theme = "dropdown",
					hijack_netrw = true,
					mappings = {
						n = {
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for _ = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
			})

			return opts
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "file_browser")
		end,
	},

	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>th",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				desc = "Close hidden buffers",
			},
			{
				"<leader>tu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close nameless buffers",
			},
		},
	},

	{
		"saghen/blink.cmp",
		opts = function(_, opts)
			opts = opts or {}
			opts.completion = opts.completion or {}
			opts.completion.menu = opts.completion.menu or {}
			opts.completion.menu.winblend = vim.o.pumblend

			opts.signature = opts.signature or {}
			opts.signature.window = opts.signature.window or {}
			opts.signature.window.winblend = vim.o.pumblend

			return opts
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
			},
		},
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = false,
			},
			per_filetype = {
				["html"] = {
					enable_close = true,
					enable_rename = true,
				},
				["javascriptreact"] = {
					enable_close = true,
					enable_rename = true,
				},
				["typescriptreact"] = {
					enable_close = true,
					enable_rename = true,
				},
			},
		},
	},
}
