return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- hanya muat untuk file lua
		opts = {
			library = {
				-- Muat tipe data untuk plugin lazy.nvim juga
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
	},

	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false,
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				"stylua",
				"prettierd",
				"eslint-lsp",
				"vtsls",
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
				"vtsls",
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
			automatic_installation = false,
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			for _, server_name in ipairs(opts.ensure_installed) do
				local server_opts = {
					capabilities = capabilities,
				}

				if server_name == "lua_ls" then
					server_opts.settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							hint = { enable = true },
						},
					}
				elseif server_name == "eslint" then
					server_opts.settings = {
						silent = true,
					}
				elseif server_name == "vtsls" then
					server_opts.settings = {
						vtsls = {
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					}
				elseif server_name == "jsonls" then
					server_opts.settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					}
				elseif server_name == "yamlls" then
					server_opts.settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					}
				end

				if server_name ~= "ts_ls" then
					require("lspconfig")[server_name].setup(server_opts)
				end
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Gunakan LspAttach untuk memuat keymaps hanya ketika LSP aktif pada buffer tersebut
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function opts(desc)
						return { buffer = ev.buf, desc = desc }
					end

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Goto definition"))
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
					
					vim.keymap.set("n", "<leader>f", function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end, opts("Format file"))

					vim.keymap.set("n", "<leader>ti", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
					end, opts("Toggle inlay hints"))

					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client and client.name == "vtsls" then
						vim.keymap.set("n", "<leader>co", function()
							vim.lsp.buf.execute_command({
								command = "typescript.organizeImports",
								arguments = { vim.api.nvim_buf_get_name(ev.buf) },
							})
						end, opts("Organize Imports"))
					end
				end,
			})
		end,
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
