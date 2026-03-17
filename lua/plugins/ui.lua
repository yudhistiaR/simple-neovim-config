return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      sidebars = { "neo-tree", "qf", "help", "snacks_dashboard" },
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "rcarriga/nvim-notify" },
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      opts.presets = opts.presets or {}
      opts.views = opts.views or {}

      opts.views.cmdline_popup = {
        position = {
          row = "20%",
          col = "50%",
        },
        size = {
          width = 50,
          height = "auto",
        },
        border = {
          style = "rounded",
        },
      }

      opts.views.cmdline_popupmenu = {
        position = {
          row = "43%",
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
        },
      }

      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          event = "notify",
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = vim.tbl_deep_extend("force", opts.commands or {}, {
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_colour = "#000000",
      render = "default",
    },
  },

  {
    "folke/snacks.nvim",
    priority = 900,
    opts = {
      scroll = { enabled = false },
      dashboard = {
        preset = {
          header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Tab>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thin",
        always_show_bufferline = true,
      },
    },
  },

  {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  dependencies = {
    "craftzdog/solarized-osaka.nvim",
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
  },
  config = function()
    local colors = require("solarized-osaka.colors").setup()
    local devicons = require("nvim-web-devicons")
    local navic_ok, navic = pcall(require, "nvim-navic")

    require("incline").setup({
      debounce_threshold = {
        falling = 50,
        rising = 10,
      },
      hide = {
        cursorline = "smart",
        focused_win = false,
        only_win = false,
      },
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 0,
      },
      highlight = {
        groups = {
          InclineNormal = {
            guibg = colors.base03 or colors.bg_dark,
            guifg = colors.fg,
          },
          InclineNormalNC = {
            guibg = colors.base02 or colors.bg_dark,
            guifg = colors.fg_dark,
          },
        },
      },
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local icon, icon_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        local readonly = vim.bo[props.buf].readonly or not vim.bo[props.buf].modifiable

        local res = {
          " ",
          icon and { icon .. " ", guifg = icon_color } or "",
          {
            filename,
            gui = modified and "bold,italic" or "bold",
          },
          modified and { " [+]", guifg = colors.yellow } or "",
          readonly and { " 󰌾", guifg = colors.orange } or "",
        }

        if props.focused and navic_ok and navic.is_available(props.buf) then
          local data = navic.get_data(props.buf)
          if data and #data > 0 then
            for _, item in ipairs(data) do
              table.insert(res, {
                { " > ", guifg = colors.comment },
                { item.icon or "", guifg = colors.blue },
                { item.name, guifg = colors.fg_dark },
              })
            end
          end
        end

        table.insert(res, " ")
        return res
      end,
    })
  end,

},

{
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local function lsp_name()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if not clients or vim.tbl_isempty(clients) then
        return "No LSP"
      end

      local names = {}
      for _, client in ipairs(clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(names, client.name)
        end
      end

      if #names == 0 then
        return "No LSP"
      end

      return table.concat(names, ", ")
    end

    require("lualine").setup({
      options = {
        theme = "solarized-osaka",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "neo-tree", "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return " " .. str .. " "
            end,
          },
        },

        lualine_b = {
          {
            "branch",
            icon = "",
            on_click = function()
              vim.cmd("Telescope git_branches")
            end,
          },
          {
            "diff",
            colored = true,
            symbols = { added = "+", modified = "~", removed = "-" },
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
            "filename",
            path = 1,
            shorting_target = 40,
            symbols = {
              modified = "[+]",
              readonly = "[RO]",
              unnamed = "[No Name]",
              newfile = "[New]",
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
          },
          {
            lsp_name,
            icon = "",
            color = { gui = "bold" },
          },
          {
            "filetype",
            colored = true,
            icon_only = false,
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

 {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
}
