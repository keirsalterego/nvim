# Neovim Configuration

My personal Neovim setup, built on [LazyVim](https://github.com/LazyVim/LazyVim) — a full
VSCode-style keymap layer, a floating integrated terminal, and language support for bash,
python, rust, c, c++, go, lua, and zig.

---

## Overview

This config keeps the LazyVim foundation and layers a few opinionated things on top:

- A complete VSCode-emulation keymap layer — `Ctrl+P`, `Ctrl+Shift+P`, `Ctrl+S`, `Ctrl+/`,
  `F12`, and friends all behave the way they do in VSCode.
- A floating, centered integrated terminal toggled with `` Ctrl+` ``.
- Autosave on focus-loss, buffer-leave, and leaving insert mode.
- The system clipboard wired up as the default register, so copy and paste just work.
- Language tooling (LSP, formatters, treesitter parsers) for the languages I actually use.

---

## Requirements

- Neovim 0.10 or newer (0.11+ recommended).
- A [Nerd Font](https://www.nerdfonts.com/) for icons.
- `git`, `ripgrep`, and a C compiler for treesitter.
- A terminal that speaks the kitty keyboard protocol / CSI-u for the full keymap set —
  kitty, wezterm, ghostty, foot, recent alacritty, or neovide. Other terminals work but
  drop a few of the `Ctrl+Shift+*` chords.
- Per-language toolchains as needed — `cargo` for rust, `go`, a zig toolchain for zls, etc.

---

## Installation

Back up any existing config first, then clone this repo into place:

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
git clone https://github.com/keirsalterego/nvim ~/.config/nvim
nvim
```

On first launch, lazy.nvim bootstraps itself and installs every plugin. LSP servers,
formatters, and parsers install on demand the first time you open a file of that type, or
you can run `:Mason` and `:checkhealth nvim-treesitter` to do it up front.

---

## Structure

```
.
|-- init.lua                       -- entry point; loads config.lazy
|-- lua/
|   |-- config/
|   |   |-- lazy.lua               -- lazy.nvim + LazyVim bootstrap
|   |   |-- options.lua            -- indentation, system clipboard
|   |   |-- keymaps.lua            -- the VSCode-style keymap layer
|   |   |-- autocmds.lua           -- autosave, per-filetype autoformat toggles
|   |-- plugins/
|       |-- terminal.lua           -- floating integrated terminal (Snacks)
|       |-- langs.lua              -- bash + zig LSP, formatters, parsers
|       |-- rust.lua               -- rustaceanvim / rust-analyzer tuning
|       |-- blink.lua              -- completion
|       |-- noice.lua              -- UI messages
|       |-- fugitive.lua           -- git
|       |-- ...                    -- and the rest
|-- KEYBINDINGS.md                 -- every shortcut, grouped, with what it does
|-- VSCODE-KEYMAPS.md              -- VSCode-comparison reference + terminal caveats
```

---

## Keybindings

The full reference lives in two files:

- [`KEYBINDINGS.md`](KEYBINDINGS.md) — every shortcut, grouped by category, with what it does.
- [`VSCODE-KEYMAPS.md`](VSCODE-KEYMAPS.md) — the same set mapped against VSCode, plus the
  per-terminal caveats and where reassigned vim defaults moved.

A few of the ones I reach for most:

| Shortcut | Action |
|----------|--------|
| `Ctrl+P` | Quick open files |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+F` | Search across the project |
| `Ctrl+B` | Toggle the file explorer |
| `Ctrl+S` | Save |
| `Ctrl+/` | Toggle comment |
| `F12` | Go to definition |
| `F2` | Rename symbol |
| `` Ctrl+` `` | Toggle the floating terminal |

LazyVim's `<leader>` (space) mappings are all still available on top of these — press
`<Space>` and wait for which-key.

---

## Languages

| Language | LSP | Formatter |
|----------|-----|-----------|
| bash / shell | bash-language-server | shfmt |
| python | basedpyright / pyright + ruff | black / ruff |
| rust | rust-analyzer (rustaceanvim) | rustfmt |
| c / c++ | clangd | clang-format |
| go | gopls | gofumpt + goimports |
| lua | lua_ls (+ lazydev) | stylua |
| zig | zls | zig fmt |

Format-on-save is intentionally off for c, c++, and yaml — format those manually with
`Shift+Alt+F`.

---

## Notable behaviors

- Indentation defaults to 4 spaces (`shiftwidth` / `tabstop`).
- `clipboard=unnamedplus` — yanks and pastes use the OS clipboard.
- Autosave writes the buffer on focus-loss, buffer-leave, and leaving insert mode, but only
  for real, named files.

---

## Customizing

- Disable a single shortcut by commenting out its line in `lua/config/keymaps.lua`.
- Change the terminal size or position via the `win` table in `lua/plugins/terminal.lua`.
- Add or remove languages in `lua/plugins/langs.lua`.

---

## Credits

Built on [LazyVim](https://github.com/LazyVim/LazyVim) by folke and contributors.
