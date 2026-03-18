return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>o", "<cmd>Neotree focus filesystem left<cr>", desc = "Focus explorer" },
      { "<leader>bf", "<cmd>Neotree toggle buffers right<cr>", desc = "Buffers" },
      { "<leader>gs", "<cmd>Neotree toggle git_status right<cr>", desc = "Git status" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        indent = {
          with_markers = true,
          indent_size = 2,
        },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },

      window = {
        position = "left",
        width = 36,
      },

      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
        window = {
          mappings = {
            ["/"] = "filter_as_you_type",
            ["<C-x>"] = "clear_filter",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["r"] = "rename",
            ["c"] = "copy",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["d"] = "delete",
            ["m"] = "move",
          },
        },
      },
    },
  },
}
