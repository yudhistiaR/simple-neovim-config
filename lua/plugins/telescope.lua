return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "^%.git/", "node_modules/" },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob",
            "!.git/*",
          },
        },
      },
    },
  },
}
