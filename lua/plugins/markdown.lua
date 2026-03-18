return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "mdx", "markdown.mdx" },
    opts = {
      file_types = { "markdown", "mdx", "markdown.mdx" },
      preset = "markdownit",
      heading = {
        enabled = true,
        position = "overlay",
      },

      highlights = {
        heading = {
          h1 = "RenderMarkdownH1",
          h2 = "RenderMarkdownH2",
          h3 = "RenderMarkdownH3",
          h4 = "RenderMarkdownH4",
          h5 = "RenderMarkdownH5",
          h6 = "RenderMarkdownH6",
        },
      },

      code = {
        enabled = true,
        shell = "bash",
        style = "full",
        highlight = "RenderMarkdownCode",
      },

      pipe = { enabled = true },
      table = { enabled = true },
    },
    config = function(_, opts)
      vim.treesitter.language.register("markdown", "mdx")
      require("render-markdown").setup(opts)
      local colors = {
        h1 = "#cb4b16", -- Orange (Solarized)
        h2 = "#859900", -- Green
        h3 = "#268bd2", -- Blue
        h4 = "#b58900", -- Yellow
        h5 = "#d33682", -- Magenta
        h6 = "#2aa198", -- Cyan
      }

      for i, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "RenderMarkdown" .. i:upper(), { fg = color, bold = true })
      end
    end,
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
    },
  },
}
