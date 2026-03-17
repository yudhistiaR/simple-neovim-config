return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      format_on_save = function()
        if vim.g.autoformat == false then
          return
        end

        return {
          timeout_ms = 3000,
          lsp_format = "fallback",
        }
      end,
    },
  },
}
