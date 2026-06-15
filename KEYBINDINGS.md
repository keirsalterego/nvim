# Keybindings Reference

Every keyboard shortcut defined in this config, with what each one does.

These are the **custom VSCode-style mappings** layered on top of LazyVim
(source: [`lua/config/keymaps.lua`](lua/config/keymaps.lua)). All of LazyVim's
default `<leader>`-PREFIXED mappings remain available on top of these — press
`<Space>` and wait for which-key, or see the
[LazyVim keymaps](https://www.lazyvim.org/keymaps).

> **Mode legend:** `n` normal · `i` insert · `v` visual · `x` visual-block/charwise ·
> `s` select · `t` terminal · `c` command-line.

---

## Files, search & command palette

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+P` | n / i / v | Quick Open — fuzzy find files (Snacks picker) |
| `Ctrl+Shift+P` | n / i / v | Command Palette — run any command (Snacks picker) |
| `Ctrl+Shift+F` | n / i / v | Search in Files — live grep across the project |
| `Ctrl+Shift+H` | n / i / v | Replace in Files — project-wide find & replace (grug-far) |
| `Ctrl+Shift+O` | n | Go to Symbol in File — LSP document symbols |
| `Ctrl+T` | n | Go to Symbol in Workspace — LSP workspace symbols |
| `Ctrl+G` | n / i | Go to Line — prompt for a line number and jump |

## Sidebar & explorer

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+B` | n / i | Toggle Sidebar — Snacks file explorer |
| `Ctrl+Shift+E` | n | Open Explorer — Snacks file explorer |

## Editors, buffers & tabs

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+W` | n | Close Editor — delete buffer, keep window layout |
| `Ctrl+N` | n | New File — open an empty buffer (`:enew`) |
| `Ctrl+\` | n | Split Editor — vertical split |
| `Ctrl+Tab` / `Ctrl+PageDown` | n / i | Next Editor — cycle to next buffer |
| `Ctrl+Shift+Tab` / `Ctrl+PageUp` | n / i | Previous Editor — cycle to previous buffer |
| `Alt+←` | n | Navigate Back — jumplist backward (`Ctrl+O`) |
| `Alt+→` | n | Navigate Forward — jumplist forward (`Ctrl+I`) |

## Save, undo & redo

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+S` | n / i / v / s | Save File (`:w`) |
| `Ctrl+Z` | n / i / v | Undo |
| `Ctrl+Y` | n / i | Redo |
| `Ctrl+Shift+Z` | n | Redo |

## Clipboard

> The system clipboard is the default register (`clipboard=unnamedplus`), so
> these mappings and plain `y`/`p` all use the OS clipboard.

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+C` | n | Copy current line |
| `Ctrl+C` | v | Copy selection |
| `Ctrl+X` | n | Cut current line |
| `Ctrl+X` | v | Cut selection |
| `Ctrl+V` | n / v / i / c | Paste (in visual, pastes over selection without clobbering the register) |
| `Ctrl+A` | n / i | Select All (`ggVG`) |
| `+` | n / x | Increment number under cursor (dial.nvim) |
| `-` | n / x | Decrement number under cursor (dial.nvim) |

## Find & replace (current file)

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+F` | n / i | Find in File — start `/` search (`n` / `N` to cycle matches) |
| `Ctrl+H` | v | Replace in Selection — start a `:s/` substitution |
| `Ctrl+D` | n | Change word under cursor; repeat with `.`, skip with `n` |
| `Ctrl+D` | v | Change selection; repeat with `.`, skip with `n` |

> `Ctrl+D` is the closest single-key stand-in for VSCode multi-cursor (no
> multi-cursor plugin is installed). It selects the word/selection and starts a
> *change* — type the replacement, press `Esc`, then `.` to repeat on the next
> match or `n` to skip it.

## Comments

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+/` (or `Ctrl+_`) | n | Toggle comment on current line (mini.comment `gcc`) |
| `Ctrl+/` (or `Ctrl+_`) | x | Toggle comment on selection (mini.comment `gc`) |

## Move, copy & delete lines

| Shortcut | Mode | Action |
|----------|------|--------|
| `Alt+↓` | n / i / v | Move line(s) down |
| `Alt+↑` | n / i / v | Move line(s) up |
| `Shift+Alt+↓` | n / v | Copy/duplicate line(s) down |
| `Shift+Alt+↑` | n / v | Copy/duplicate line(s) up |
| `Ctrl+Shift+K` | n / i | Delete current line |
| `Ctrl+Enter` | i | Insert a new line below |
| `Ctrl+Shift+Enter` | i | Insert a new line above |

## Indent & whitespace

| Shortcut | Mode | Action |
|----------|------|--------|
| `Tab` | v | Indent selection (keeps selection) |
| `Shift+Tab` | v | Outdent selection (keeps selection) |
| `Ctrl+]` | n | Indent current line |
| `Ctrl+Backspace` | i | Delete word to the left |
| `Ctrl+Delete` | i | Delete word to the right |
| `Alt+Z` | n | Toggle word wrap |

## Code navigation & LSP

| Shortcut | Mode | Action |
|----------|------|--------|
| `F12` | n | Go to Definition |
| `Shift+F12` | n | Go to References |
| `Ctrl+F12` | n | Go to Implementation |
| `Alt+F12` | n | Peek Definition |
| `K` | n | Hover documentation (vim/LSP default) |
| `Ctrl+.` | n / x | Quick Fix / Code Action |
| `F2` | n | Rename Symbol (inc-rename, live preview) |
| `Shift+Alt+F` | n / x | Format Document (conform.nvim) |

## Problems & diagnostics

| Shortcut | Mode | Action |
|----------|------|--------|
| `Ctrl+Shift+M` | n | Toggle Problems panel (Trouble diagnostics) |
| `F8` | n | Go to next problem/diagnostic |
| `Shift+F8` | n | Go to previous problem/diagnostic |

## Integrated terminal

| Shortcut | Mode | Action |
|----------|------|--------|
| `` Ctrl+` `` | n / i / t | Toggle the floating terminal |
| `Esc Esc` | t | Exit terminal mode → back to normal mode |

If `` Ctrl+` `` doesn't fire in your terminal, LazyVim's `<leader>ft` (float)
and `<leader>fT` (fullscreen) still open a terminal.

---

## Reassigned vim defaults

Full VSCode emulation reuses some keys vim already owned. Here's where the old
behavior moved:

| Key | Original vim behavior | Where it lives now |
|-----|-----------------------|--------------------|
| `Ctrl+A` | Increment number | `+` |
| `Ctrl+X` | Decrement number | `-` |
| `Ctrl+V` | Block-visual mode | `Ctrl+Q` (built-in vim alias) |
| `Ctrl+W` | Window prefix | Move between windows with `Ctrl+H/J/K/L`; `<leader>w` for the window menu |
| `Ctrl+Z` | Suspend Neovim | Use `:suspend` or your shell |
| `Ctrl+F` | Page down | `PageDown` |
| `Ctrl+D` | Half-page down | `PageDown`; `Ctrl+D` is now change-word |

> **Window navigation** (`Ctrl+H/J/K/L`) is preserved — `Ctrl+H` was intentionally
> *not* hijacked so left-window navigation keeps working. In-file replace via
> `:%s/old/new/g` is also preserved.

---

## ⚠️ Terminal caveat

Chords involving `Ctrl+Shift+*`, `Ctrl+.`, and `` Ctrl+` `` only work in
terminals that speak the **kitty keyboard protocol / CSI-u** (kitty, wezterm,
ghostty, foot, neovide, recent alacritty). In other terminals, Shift is dropped
for letters and these may fall back to the non-Shift mapping or not fire at all.
See [`VSCODE-KEYMAPS.md`](VSCODE-KEYMAPS.md) for the per-key fallback table.
