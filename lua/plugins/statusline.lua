return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local mode_icons = {
        n = "",
        i = "󰏫",
        v = "󰈈",
        ["\22"] = "󰘎",
        V = "󰈈",
        c = "",
        R = "",
        t = "",
      }

      local function mode_with_icon(str)
        local mode = vim.api.nvim_get_mode().mode
        local icon = mode_icons[mode] or "󰀘"
        return string.format("%s %s", icon, str)
      end

      local function file_icon()
        local filename = vim.fn.expand("%:t")
        local devicons = require("nvim-web-devicons")
        local icon = devicons.get_icon(filename, nil, { default = true })
        return (icon or "") .. " "
      end

      local function file_icon_color()
        local filename = vim.fn.expand("%:t")
        local devicons = require("nvim-web-devicons")
        local _, color = devicons.get_icon_color(filename, nil, { default = true })
        return { fg = color }
      end

      require("lualine").setup({
        options = {
          theme = "solarized-osaka",
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "neo-tree", "snacks_dashboard" },
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = mode_with_icon,
              separator = { left = "", right = "" },
              padding = { left = 1, right = 1 },
            },
          },

          lualine_b = {
            {
              "branch",
              icon = "",
              on_click = function()
                vim.cmd("Telescope git_branches")
              end,
            },
            {
              "diff",
              colored = true,
              symbols = { added = " ", modified = " ", removed = " " },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = "󰠠 ",
              },
              update_in_insert = false,
              on_click = function()
                vim.diagnostic.setqflist()
                vim.cmd("copen")
              end,
            },
          },

          lualine_c = {
            {
              file_icon,
              color = file_icon_color,
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1,
              shorting_target = 40,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = " [No Name]",
                newfile = " [New]",
              },
              on_click = function()
                require("telescope.builtin").find_files()
              end,
            },
          },

          lualine_x = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
              icon = "",
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "right" },
            },
          },

          lualine_y = {
            {
              "progress",
              fmt = function(str)
                return " " .. str .. " "
              end,
            },
          },

          lualine_z = {
            {
              "location",
              fmt = function(str)
                return " " .. str .. " "
              end,
              on_click = function()
                vim.cmd("normal! gg")
              end,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy" },
      })

      local group = vim.api.nvim_create_augroup("LualineRefreshEvents", { clear = true })
      vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "BufEnter", "DiagnosticChanged" }, {
        group = group,
        callback = function()
          require("lualine").refresh()
        end,
      })
    end,
  },
}
