# Dokumentasi Konfigurasi Neovim

Konfigurasi ini dibuat untuk kebutuhan **web development** dengan fokus pada:

* ringan untuk perangkat spek rendah
* nyaman untuk React / TypeScript / JavaScript
* tetap modern tanpa terlalu banyak plugin berat
* mudah dipahami dan dikembangkan pelan-pelan

Konfigurasi ini **tidak memakai LazyVim**, tetapi memakai **lazy.nvim** sebagai plugin manager utama.

---

# Tujuan Konfigurasi

Setup ini dirancang untuk:

* React / Next.js
* TypeScript / JavaScript
* HTML / CSS / Tailwind
* JSON / YAML
* Bash
* Lua untuk konfigurasi Neovim

Fokus utama:

* startup tetap ringan
* autocomplete dan LSP berjalan
* formatting aman
* sidebar explorer modern
* UI tetap enak dilihat tapi tidak berlebihan

---

# Struktur Folder

```text
~/.config/nvim/
├── init.lua
└── lua
    ├── config
    │   ├── diagnostics.lua
    │   ├── keymaps.lua
    │   ├── lazy.lua
    │   └── options.lua
    └── plugins
        ├── coding.lua
        ├── editor.lua
        ├── format.lua
        ├── hipatterns.lua
        ├── lsp.lua
        ├── neo-tree.lua
        ├── treesitter.lua
        └── ui.lua
```

---

# File Utama

## `init.lua`

File entry point Neovim.

Contoh isi:

```lua
require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.diagnostics")
```

Urutannya penting:

1. options
2. keymaps
3. plugin manager
4. diagnostics

---

# Konfigurasi Dasar

## `lua/config/options.lua`

Berisi pengaturan inti editor seperti:

* leader key
* line number
* relative number
* split behavior
* scroll offset
* indentasi
* tampilan end-of-buffer

Contoh pengaturan penting:

* `vim.g.mapleader = " "`
* `vim.opt.number = true`
* `vim.opt.relativenumber = true`
* `vim.opt.fillchars = { eob = " " }`
* `vim.opt.expandtab = true`
* `vim.opt.shiftwidth = 2`
* `vim.opt.tabstop = 2`
* `vim.opt.splitbelow = true`
* `vim.opt.splitright = true`

### Catatan

`fillchars = { eob = " " }` dipakai untuk menghilangkan tanda `~` di bawah buffer.

---

## `lua/config/keymaps.lua`

Berisi semua shortcut utama.

### Keymap dasar

* `<leader>w` — simpan file
* `<leader>q` — keluar
* `<leader>h` — hapus highlight pencarian

### Explorer / navigasi

* `<leader>e` — toggle Neo-tree
* `<leader>o` — fokus ke Neo-tree
* `<leader>bf` — toggle buffer panel
* `<leader>gs` — toggle git status panel

### Telescope

* `<leader>ff` — cari file
* `<leader>fg` — cari teks
* `<leader>fb` — cari buffer
* `<leader>fr` — recent files
* `<leader>fk` — tampilkan daftar seluruh keymap aktif (Telescope keymaps)
* `<leader>?` — alias cepat untuk daftar keymap
* `<leader>qs` — simpan session
* `<leader>qr` — restore session
* `<leader>qd` — hapus session saat ini
* `<leader>ql` — daftar session
* `;f` — cari file cepat
* `;r` — live grep cepat
* `;;` — resume telescope terakhir
* `;e` — diagnostics
* `;s` — treesitter symbols
* `;t` — help tags

### Split / tab

* `ss` — horizontal split
* `sv` — vertical split
* `sh sj sk sl` — pindah window
* `<Tab>` — next tab
* `<S-Tab>` — previous tab

### LSP

* `gd` — goto definition
* `gr` — references
* `gi` — implementation
* `K` — hover
* `<leader>ca` — code action
* `<leader>rn` — rename symbol
* `<leader>ti` — toggle inlay hints

### Edit helper

* `x` — hapus karakter tanpa masuk register
* `<leader>p` — paste yank terakhir
* `<leader>d` — delete tanpa yanking
* `<C-a>` / `<C-x>` — increment / decrement cerdas via `dial.nvim`

---

## `lua/config/diagnostics.lua`

Mengatur tampilan diagnostics dari LSP.

Fungsinya:

* menampilkan error/warning/hint/info di sign column
* mengatur virtual text
* mengganti huruf `E`, `W`, dll menjadi ikon

Contoh perilaku:

* error pakai ikon
* warning pakai ikon
* underline aktif
* diagnostic update tidak berjalan saat insert

---

## `lua/config/lazy.lua`

Bootstrap `lazy.nvim`.

Konfigurasi ini memakai `lazy.nvim` langsung, tanpa framework tambahan.

Fitur yang biasanya diaktifkan:

* plugin loading
* cache performa
* checker update dimatikan atau disederhanakan untuk perangkat ringan
* beberapa plugin RTP bawaan bisa dimatikan jika perlu

Contoh arah konfigurasi ringan:

* cache aktif
* update checker nonaktif
* disabled plugins secukupnya seperti `gzip`, `zipPlugin`, `tarPlugin`, `tohtml`, `tutor`

---

# Plugin Utama

## `lua/plugins/ui.lua`

Berisi semua plugin antarmuka.

### Plugin yang dipakai

* `craftzdog/solarized-osaka.nvim` — colorscheme utama
* `nvim-lualine/lualine.nvim` — statusline
* `b0o/incline.nvim` — winbar/interaktif judul buffer
* `folke/noice.nvim` — cmdline / popup UI
* `rcarriga/nvim-notify` — notifikasi
* `folke/snacks.nvim` — dashboard / utilitas UI ringan
* `akinsho/bufferline.nvim` — tab line
* `folke/zen-mode.nvim` — mode fokus

### Tujuan UI

* editor bisa transparan jika diinginkan
* sidebar tetap solid agar jelas terpisah
* statusline informatif
* command line popup tetap rapi

### Catatan performa

Untuk perangkat lemah, plugin UI ini adalah bagian pertama yang bisa disederhanakan.

Kalau perlu sangat ringan, pertimbangkan menonaktifkan:

* `noice.nvim`
* `nvim-notify`
* `bufferline.nvim`
* `incline.nvim`
* sebagian fitur `snacks.nvim`

---

## `lua/plugins/session.lua`

Menambahkan manajemen session memakai `rmagatti/auto-session`.

### Fitur

* auto-save session per project
* restore session manual saat dibutuhkan
* daftar session via `:AutoSession search`
* session tidak dibuat untuk direktori umum seperti home dan Downloads
* tidak menyimpan buffer UI sementara (`neo-tree`, `TelescopePrompt`, `lazy`, dll) agar restore session lebih aman
* session di-save otomatis saat `VimLeavePre`, `FocusLost`, dan `VimSuspend`

### Catatan kompatibilitas

* fitur session ini tidak menonaktifkan Treesitter atau LSP
* saat `SessionRestore`, buffer akan dibuka ulang lalu plugin berbasis `BufRead` (termasuk Treesitter/LSP attach) tetap berjalan normal
* untuk kasus laptop mati total (power loss), tidak ada jaminan 100%, tapi autosave di `FocusLost`/`VimSuspend` membantu mengurangi risiko kehilangan session

## `lua/plugins/neo-tree.lua`

Explorer utama berbasis sidebar.

### Fungsi

* sidebar file modern
* create file/folder
* rename
* copy / cut / paste
* delete
* filter/search di sidebar
* follow current file
* git status

### Mapping penting di dalam Neo-tree

* `/` — filter
* `a` — tambah file
* `A` — tambah folder
* `r` — rename
* `c` — copy
* `x` — cut
* `p` — paste
* `d` — delete
* `m` — move

### Catatan

Neo-tree dipakai sebagai explorer utama. Sebaiknya jangan menggunakan banyak explorer sekaligus untuk menjaga performa.

---

## `lua/plugins/editor.lua`

Berisi plugin yang membantu pekerjaan editing sehari-hari.

### Plugin yang dipakai

* `nvim-telescope/telescope.nvim`
* `nvim-telescope/telescope-fzf-native.nvim`
* `dinhhuy258/git.nvim`
* `kazhala/close-buffers.nvim`
* `brenoprata10/nvim-highlight-colors` atau `mini.hipatterns` sesuai preferensi

### Fungsi utama

* pencarian file dan teks
* file browser popup
* buffer picker
* diagnostics picker
* treesitter symbol picker
* git helper
* tutup hidden buffer / nameless buffer

### Catatan performa

Kalau ingin lebih ringan:

* tetap pakai Telescope
* hapus extension yang jarang dipakai
* pilih salah satu antara highlight warna yang berat atau yang lebih ringan

---

## `lua/plugins/coding.lua`

Berisi plugin untuk produktivitas coding.

### Plugin yang dipakai

* `smjonas/inc-rename.nvim`
* `nvim-mini/mini.bracketed`
* `monaqa/dial.nvim`
* `zbirenbaum/copilot.lua` (opsional)

### Fungsi utama

#### `inc-rename.nvim`

Rename symbol secara lebih interaktif.

#### `mini.bracketed`

Navigasi cepat antar file, quickfix, treesitter, dan item bracketed lainnya.

#### `dial.nvim`

Increment / decrement yang lebih pintar.

Contoh yang bisa dinaik-turunkan:

* angka desimal
* hex
* tanggal
* boolean
* semver
* `let` ↔ `const`

#### `copilot.lua`

AI suggestion.

### Catatan performa

Untuk spek rendah, `copilot.lua` sebaiknya dianggap **opsional**.

Kalau editor terasa berat:

* nonaktifkan dulu Copilot
* fokus ke LSP + cmp biasa

---

## `lua/plugins/treesitter.lua`

Berisi konfigurasi syntax tree parser.

### Tujuan

* syntax highlighting lebih baik
* indent lebih akurat
* mendukung React / TSX / TypeScript

### Parser yang disarankan

Untuk setup ringan, cukup install parser yang benar-benar dipakai:

* `lua`
* `vim`
* `vimdoc`
* `javascript`
* `typescript`
* `tsx`
* `html`
* `css`
* `json`
* `yaml`
* `bash`

### Catatan penting

Untuk perangkat rendah:

* jangan install terlalu banyak parser
* cukup yang dipakai sehari-hari

Kalau syntax React tidak berwarna:

1. cek filetype
2. cek parser `tsx`
3. jalankan `:TSInstall typescript tsx javascript`

---

## `lua/plugins/lsp.lua`

Berisi konfigurasi LSP.

### Fokus server utama untuk web dev

* `ts_ls`
* `tailwindcss`
* `html`
* `cssls`
* `jsonls`
* `yamlls`
* `lua_ls`
* `bashls`
* `dockerls` (opsional)

### Peran plugin

* `mason.nvim` — installer tools / server
* `mason-lspconfig.nvim` — integrasi installer dengan lspconfig
* `nvim-lspconfig` — setup server

### Catatan penting

Setup ini harus mengikuti gaya Neovim baru:

* `vim.lsp.config(...)`
* `vim.lsp.enable(...)`

Jangan mencampur dengan gaya lama `require("lspconfig")...setup(...)` kalau ingin menghindari warning deprecated.

### Troubleshooting React / TSX

Kalau file React menunjukkan `No LSP`:

1. cek `:set ft?`
2. cek `:LspInfo`
3. cek `:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))`
4. pastikan `ts_ls` attach

---

## `lua/plugins/format.lua`

Berisi formatter.

### Plugin utama

* `stevearc/conform.nvim`

### Formatter yang dipakai

* `prettierd` / `prettier` untuk JS/TS/React/JSON/YAML/Markdown/CSS/HTML
* `stylua` untuk Lua

### Catatan performa

Kalau `prettier` timeout di React project:

* naikkan `timeout_ms`
* gunakan `prettierd` dulu lalu fallback ke `prettier`
* pertimbangkan `format_after_save` bila `format_on_save` terlalu berat

### Rekomendasi

Untuk web dev:

* utamakan `prettierd`
* fallback ke `prettier`
* timeout lebih longgar

---

## `lua/plugins/hipatterns.lua`

Opsional untuk menyorot kata-kata penting.

### Contoh kata yang disorot

* TODO
* FIXME
* HACK
* NOTE
* BUG
* PERF

Bisa juga dipakai untuk highlight warna hex.

### Catatan

Kalau sudah ada plugin warna lain, hindari duplikasi fungsi.

---

# Completion

## `blink.cmp`

Completion engine utama.

### Tujuan

* source dari LSP
* source dari path
* source dari buffer
* dokumentasi popup
* signature help

### Saran konfigurasi

* Enter untuk accept completion
* `lsp`, `path`, `buffer` sebagai source utama
* fuzzy implementation pakai `lua` untuk menghindari masalah binary Rust

### Catatan

Kalau Enter malah membuat baris baru:

* berarti keymap cmp belum mengambil alih `<CR>`
* harus diatur agar `<CR>` melakukan accept

---

# Statusline dan Winbar

## Statusline

Tujuan statusline:

* mode
* branch git
* diff
* diagnostics
* nama file
* LSP aktif
* filetype
* progress
* location

Kalau statusline menampilkan `No LSP` padahal LSP sudah attach, biasanya fungsi pembaca client yang bermasalah atau belum refresh saat `LspAttach`.

## Incline

Digunakan sebagai winbar interaktif.

Bisa menampilkan:

* icon file
* nama file
* status modified
* readonly
* breadcrumb konteks kode

---

# Diagnostik

Tampilan diagnostik disarankan meliputi:

* virtual text
* sign column
* underline
* severity sort

Untuk icon, bisa pakai:

* error
* warning
* hint
* info

Kalau font terminal belum mendukung icon, gunakan simbol Unicode sederhana.

---

# Tema

## Solarized Osaka

Tema utama adalah `craftzdog/solarized-osaka.nvim`.

### Tujuan styling

* editor bisa transparan jika diinginkan
* sidebar lebih gelap agar jelas terpisah
* floating window tetap solid
* lualine selaras dengan tema
* Telescope dan Neo-tree memakai highlight yang serasi

### Catatan

Kalau tampilan terlalu menyatu:

* buat editor transparan
* biarkan sidebar dan float tetap solid
* bedakan highlight separator dan border

---

# Performa

Konfigurasi ini juga diarahkan agar tetap usable di perangkat sederhana.

## Rekomendasi untuk perangkat rendah

### Tetap dipakai

* `lazy.nvim`
* `nvim-lspconfig`
* `mason.nvim`
* `blink.cmp`
* `conform.nvim`
* `telescope.nvim`
* `nvim-treesitter`
* `neo-tree.nvim`
* `lualine.nvim`

### Sebaiknya opsional / bisa dimatikan

* `noice.nvim`
* `nvim-notify`
* `bufferline.nvim`
* `incline.nvim`
* `snacks.nvim` fitur berat
* `copilot.lua`
* plugin warna tambahan yang terus aktif

### Tips tambahan

* batasi parser Treesitter
* batasi server LSP ke yang benar-benar dipakai
* jangan gunakan explorer ganda
* pakai `prettierd` bila memungkinkan
* matikan auto-update checker yang tidak perlu

---

# Instalasi Dependensi Sistem

## Arch Linux

Contoh paket dasar:

```bash
sudo pacman -S --needed base-devel git curl unzip ripgrep fd nodejs npm python-pip neovim
```

Python host:

```bash
pip install --user pynvim
```

### Tool penting

* `base-devel` — compiler dan make
* `ripgrep` — Telescope grep
* `fd` — Telescope find files
* `nodejs` / `npm` — TypeScript ecosystem

---

# Alur Setup dari Nol

1. install Neovim dan dependensi sistem
2. pasang `lazy.nvim`
3. siapkan struktur folder config
4. isi `init.lua`
5. isi `options.lua`, `keymaps.lua`, `lazy.lua`
6. tambahkan file plugin
7. buka Neovim
8. jalankan `:Lazy sync`
9. cek `:Mason`
10. install parser Treesitter jika perlu

---

# Troubleshooting

## 1. `module 'nvim-treesitter.configs' not found`

Penyebab umum:

* plugin belum benar-benar terinstall
* config terlalu cepat dipanggil
* state plugin rusak

Solusi:

* sederhanakan dulu config Treesitter
* jalankan `:Lazy sync`
* cek plugin benar-benar ada
* baru aktifkan setup lengkap

## 2. React / TSX tidak berwarna

Cek:

* `:set ft?`
* parser `typescript` dan `tsx`
* `:TSInstall typescript tsx javascript`

## 3. `No LSP` di file React

Cek:

* `:LspInfo`
* `:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))`
* root project (`package.json`, `tsconfig.json`, `.git`)

## 4. Autocomplete muncul tapi tidak berguna

Kemungkinan:

* source LSP belum aktif
* completion hanya dari buffer/path
* LSP belum attach

## 5. Enter membuat baris baru saat completion

Penyebab:

* keymap cmp belum menangani `<CR>`

Solusi:

* atur `<CR>` untuk accept completion

## 6. Prettier timeout di project React

Penyebab:

* project besar
* formatter lambat
* timeout terlalu kecil

Solusi:

* naikkan timeout
* gunakan `prettierd`
* pertimbangkan `format_after_save`

## 7. Diagnostic sign masih huruf `E`

Penyebab:

* sign belum diubah ke icon

Solusi:

* definisikan custom diagnostic sign di `diagnostics.lua`

---

# Command Penting

* `:Lazy sync`
* `:Lazy reload <plugin>`
* `:Mason`
* `:LspInfo`
* `:TSInstall typescript tsx javascript`
* `:TSUpdate`
* `:ConformInfo`
* `:checkhealth`

---

# Catatan Akhir

Konfigurasi ini sengaja dibuat **modular** agar mudah dibaca:

* `config/` untuk pengaturan dasar
* `plugins/` untuk fitur editor

Kalau ada masalah, periksa satu lapis demi satu lapis:

1. filetype
2. Treesitter
3. LSP
4. completion
5. formatter
6. UI

Untuk perangkat ringan, prinsip utamanya:

**sedikit plugin, tapi semuanya benar-benar dipakai**.
