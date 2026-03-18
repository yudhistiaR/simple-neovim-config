vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown", "mdx" },
  callback = function()
    vim.opt.conceallevel = 2
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.mdx",
  callback = function()
    vim.opt_local.filetype = "markdown.mdx"
  end,
})
