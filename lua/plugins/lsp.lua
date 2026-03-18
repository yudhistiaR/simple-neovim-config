return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local function setup(server)
        local opts = {
          capabilities = capabilities,
        }

        -- Custom settings for specific servers
        if server == "lua_ls" then
          opts.settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              hint = { enable = true },
            },
          }
        elseif server == "ts_ls" then
          opts.single_file_support = true
        elseif server == "eslint" then
          opts.root_dir = require("lspconfig").util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js", "package.json")
          opts.on_new_config = function(config, new_rootdir)
            config.settings.silent = true
          end
        elseif server == "yamlls" then
          opts.settings = {
            yaml = { keyOrdering = false },
          }
        end

        require("lspconfig")[server].setup(opts)
      end

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "tailwindcss",
          "html",
          "cssls",
          "jsonls",
          "yamlls",
          "lua_ls",
          "bashls",
          "dockerls",
        },
        handlers = {
          function(server_name)
            setup(server_name)
          end,
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
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
          winblend = 0,
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
