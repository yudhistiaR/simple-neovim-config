return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"prettierd",
				"eslint-lsp",
			},
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"ts_ls",
				"tailwindcss",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"lua_ls",
				"bashls",
				"dockerls",
				"eslint",
			},
			handlers = {
				function(server_name)
					local capabilities = require("blink.cmp").get_lsp_capabilities()
					local opts = {
						capabilities = capabilities,
					}

					if server_name == "lua_ls" then
						opts.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
								hint = { enable = true },
							},
						}
					elseif server_name == "eslint" then
						opts.settings = {
							silent = true,
						}
					end

					require("lspconfig")[server_name].setup(opts)
				end,
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
		},
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "fallback_to_mappings" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
					show_in_snippet = true,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				menu = {
					auto_show = true,
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 150,
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
