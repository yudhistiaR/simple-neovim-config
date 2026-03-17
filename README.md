# Neovim Config Pribadi

Konfigurasi Neovim ringan untuk kebutuhan harian web development (JS/TS/React, Lua, Bash) tanpa framework tambahan seperti LazyVim.

## Fokus
- Startup cepat dan nyaman di perangkat spek rendah
- LSP + autocomplete + formatting siap pakai
- Struktur modular, mudah diubah pelan-pelan

## Struktur Inti
```text
.
├── init.lua
└── lua
    ├── config/   # options, keymaps, lazy, diagnostics
    └── plugins/  # ui, lsp, treesitter, telescope, neo-tree, format, session
```

## Stack Utama
- Plugin manager: `lazy.nvim`
- LSP: `nvim-lspconfig` + `mason.nvim`
- Completion: `blink.cmp`
- Formatter: `conform.nvim` (`prettierd/prettier`, `stylua`)
- Navigasi: `telescope.nvim`, `neo-tree.nvim`
- Syntax: `nvim-treesitter`

## Keymap Penting
- `<leader>w` simpan
- `<leader>q` keluar
- `<leader>e` toggle file explorer
- `<leader>ff` cari file (Telescope)
- `<leader>fg` live grep
- `gd` goto definition
- `K` hover docs
- `<leader>ca` code action

## Perintah Penting
- `:Lazy sync`
- `:Mason`
- `:LspInfo`
- `:ConformInfo`
- `:checkhealth`

## Dependensi Sistem Minimal
- `neovim`, `git`, `ripgrep`, `fd`, `nodejs`, `npm`, `python` + `pynvim`

## Catatan
- Dokumentasi AI agent: lihat `AI_AGENT.md`
- Prinsip config ini: **plugin seperlunya, stabil, dan benar-benar dipakai**
