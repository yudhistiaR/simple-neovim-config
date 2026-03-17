# Panduan AI Agent untuk Konfigurasi Neovim Ini

Dokumen ini membantu AI agent (mis. Codex/LLM assistant) saat melakukan perubahan pada repo ini.

## Tujuan Repo

Konfigurasi Neovim ringan untuk web development (React/TS/JS) dengan `lazy.nvim`.

## Struktur Penting

- `init.lua` — entry point.
- `lua/config/*.lua` — opsi inti, keymap, lazy bootstrap, diagnostics, autocmd.
- `lua/plugins/*.lua` — deklarasi dan konfigurasi plugin.
- `README.md` — dokumentasi pengguna.

## Aturan Perubahan

1. **Perubahan kecil & terarah**
   - Hindari refactor besar jika tidak diminta.
2. **Jaga konsistensi gaya**
   - Ikuti pola yang sudah ada (nama variabel, komentar blok, urutan map/plugin).
3. **Update dokumentasi**
   - Jika menambah keymap/fitur yang terlihat user, perbarui `README.md`.
4. **Cek konflik keymap**
   - Untuk keymap baru, pastikan tidak bentrok pada kombinasi `mode + lhs` di `lua/config/keymaps.lua`.
5. **Jangan menambah dependensi tanpa alasan jelas**
   - Prioritaskan setup ringan dan stabil.

## Checklist Sebelum Commit

- [ ] Perubahan hanya menyentuh file relevan.
- [ ] `README.md` ikut diupdate jika behavior user-facing berubah.
- [ ] Tidak ada duplikasi `mode + lhs` pada keymap.
- [ ] Diff mudah dibaca dan pesan commit ringkas.

## Contoh Verifikasi Cepat

```bash
# lihat perubahan
 git diff -- lua/config/keymaps.lua README.md AI_AGENT.md

# cari keymap tertentu
 rg '"<leader>fk"|"<leader>\\?"' -n lua/config/keymaps.lua
```
