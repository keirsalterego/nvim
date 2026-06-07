# VSCode Keymaps for Neovim (LazyVim)

A full **VSCode-emulation** layer on top of LazyVim, plus a floating integrated
terminal and coding language support for **bash, python, rust, c, c++, go, lua, zig**.

- Keymaps: [`lua/config/keymaps.lua`](lua/config/keymaps.lua)
- Floating terminal: [`lua/plugins/terminal.lua`](lua/plugins/terminal.lua)
- Languages (bash/zig + parsers): [`lua/plugins/langs.lua`](lua/plugins/langs.lua)
- Clipboard (`clipboard=unnamedplus`): [`lua/config/options.lua`](lua/config/options.lua)

> After pulling these changes, run `:Lazy sync` then `:LazyExtras` is not
> needed — just restart Neovim. New LSP servers/formatters install on first use
> (or run `:Mason`). Check parser status with `:checkhealth nvim-treesitter`.

---

## ⚠️ Terminal limitations (read this first)

Some VSCode chords **cannot be detected by a terminal** unless your terminal
emulator speaks the **kitty keyboard protocol / CSI-u**. Neovim 0.10+ enables it
automatically on supported terminals:

✅ kitty · wezterm · ghostty · foot · recent alacritty · neovide (GUI)
❌ default gnome-terminal/konsole/xterm/tmux (often) — Shift is dropped for letters

Affected keys (work fully only on supported terminals):

| Key | Falls back to | In an unsupported terminal |
|-----|---------------|----------------------------|
| `Ctrl+Shift+P` / `Ctrl+Shift+F` / `Ctrl+Shift+H` / `Ctrl+Shift+O` / `Ctrl+Shift+E` / `Ctrl+Shift+K` / `Ctrl+Shift+M` | `Ctrl+P` etc. | Shift ignored → triggers the non-shift mapping |
| `Ctrl+.` (Quick Fix) | — | may not fire; use `<leader>ca` |
| `` Ctrl+` `` (Terminal) | — | may not fire; use `<leader>ft` |
| `Ctrl+Enter` / `Shift+Alt+arrows` | — | may not fire |

These are documented per-row below in the **Notes** column.

---

## What changed in vim's defaults (and where it went)

Because full emulation reuses keys vim already owns:

| Reassigned key | Old vim behavior | New home for old behavior |
|----------------|------------------|---------------------------|
| `Ctrl+A` | increment number | **`+`** |
| `Ctrl+X` | decrement number | **`-`** |
| `Ctrl+V` | block-visual mode | **`Ctrl+Q`** (built-in vim alias) |
| `Ctrl+W` | window prefix | windows: `<C-h/j/k/l>` to move, `<leader>w` menu |
| `Ctrl+Z` | suspend Neovim | use `:suspend` / your shell |
| `Ctrl+F` | page down | `PageDown` / `<C-d>`-style scroll via `<C-e>` |
| `Ctrl+D` | half-page down | `PageDown`; `Ctrl+D` now = change-word |
| `Ctrl+/` | (LazyVim terminal) | terminal moved to `` Ctrl+` `` |

Window navigation (`Ctrl+h/j/k/l`) and in-file replace via `:%s/old/new/g` are
**preserved** — `Ctrl+H` was intentionally *not* hijacked so left-window nav keeps working.

---

## Keymap reference

### Files, search & navigation

| VSCode | Neovim key | Mode | Action | Notes |
|--------|-----------|------|--------|-------|
| Quick Open | `Ctrl+P` | n/i/v | Find files (Snacks picker) | |
| Command Palette | `Ctrl+Shift+P` | n/i/v | Command picker | CSI-u terminal |
| Search in Files | `Ctrl+Shift+F` | n/i/v | Live grep | CSI-u terminal |
| Replace in Files | `Ctrl+Shift+H` | n/i/v | grug-far | CSI-u terminal |
| Go to Symbol in File | `Ctrl+Shift+O` | n | LSP document symbols | CSI-u terminal |
| Go to Symbol in Workspace | `Ctrl+T` | n | LSP workspace symbols | |
| Go to Line | `Ctrl+G` | n/i | Prompt + jump | |
| Navigate Back | `Alt+←` | n | Jumplist back (`<C-o>`) | |
| Navigate Forward | `Alt+→` | n | Jumplist forward (`<C-i>`) | |

### Sidebar & editors

| VSCode | Neovim key | Mode | Action | Notes |
|--------|-----------|------|--------|-------|
| Toggle Sidebar | `Ctrl+B` | n/i | Snacks explorer | |
| Explorer | `Ctrl+Shift+E` | n | Snacks explorer | CSI-u terminal |
| Close Editor | `Ctrl+W` | n | Delete buffer (keep layout) | |
| New File | `Ctrl+N` | n | `:enew` | |
| Split Editor | `Ctrl+\` | n | Vertical split | |
| Next Editor | `Ctrl+Tab` / `Ctrl+PageDown` | n/i | Next buffer | |
| Previous Editor | `Ctrl+Shift+Tab` / `Ctrl+PageUp` | n/i | Previous buffer | |

### Editing

| VSCode | Neovim key | Mode | Action | Notes |
|--------|-----------|------|--------|-------|
| Save | `Ctrl+S` | n/i/v/s | `:w` | |
| Undo | `Ctrl+Z` | n/i/v | Undo | |
| Redo | `Ctrl+Y` / `Ctrl+Shift+Z` | n/i | Redo | |
| Copy | `Ctrl+C` | n=line, v=selection | Yank to clipboard | |
| Cut | `Ctrl+X` | n=line, v=selection | Delete to clipboard | |
| Paste | `Ctrl+V` | n/v/i/c | Paste clipboard | block-visual moved to `Ctrl+Q` |
| Select All | `Ctrl+A` | n/i | `ggVG` | |
| Find in File | `Ctrl+F` | n/i | `/` search (`n`/`N` to cycle) | |
| Replace in Selection | `Ctrl+H` | v | `:s/` | normal-mode `Ctrl+H` = window-left |
| Toggle Comment | `Ctrl+/` | n/v | mini.comment `gcc`/`gc` | also `Ctrl+_` |
| Move Line Up/Down | `Alt+↑` / `Alt+↓` | n/i/v | Move line(s) | |
| Copy Line Up/Down | `Shift+Alt+↑` / `Shift+Alt+↓` | n/v | Duplicate line(s) | CSI-u terminal |
| Delete Line | `Ctrl+Shift+K` | n/i | `dd` | CSI-u terminal |
| Insert Line Below/Above | `Ctrl+Enter` / `Ctrl+Shift+Enter` | i | Open new line | CSI-u terminal |
| Indent / Outdent | `Tab` / `Shift+Tab` (v), `Ctrl+]` (n) | v/n | Shift right/left, keep selection | |
| Delete Word Left/Right | `Ctrl+Backspace` / `Ctrl+Delete` | i | Delete word | terminal-dependent |
| Toggle Word Wrap | `Alt+Z` | n | `set wrap!` | |
| Add Selection to Next Match | `Ctrl+D` | n/v | change-word + repeat (`.`/`n`) | see below |
| Increment / Decrement | `+` / `-` | n/v | dial.nvim | |

> **`Ctrl+D` (multi-cursor)**: true multi-cursor needs a plugin (none installed).
> `Ctrl+D` instead selects the word under the cursor and starts a *change* — type
> the replacement, press `Esc`, then `.` to repeat on the next match or `n` to
> skip it. Want real multi-cursor? Ask to add `mg979/vim-visual-multi`.

### Code / LSP

| VSCode | Neovim key | Mode | Action | Notes |
|--------|-----------|------|--------|-------|
| Go to Definition | `F12` | n | LSP definitions | |
| Go to References | `Shift+F12` | n | LSP references | |
| Go to Implementation | `Ctrl+F12` | n | LSP implementations | |
| Peek Definition | `Alt+F12` | n | LSP definitions picker | |
| Hover | `K` | n | LSP hover (vim default) | |
| Quick Fix / Code Action | `Ctrl+.` | n/v | `vim.lsp.buf.code_action` | CSI-u terminal |
| Rename Symbol | `F2` | n | inc-rename (live preview) | |
| Format Document | `Shift+Alt+F` | n/v | conform.nvim | CSI-u terminal |
| Problems Panel | `Ctrl+Shift+M` | n | Trouble diagnostics | CSI-u terminal |
| Next / Previous Problem | `F8` / `Shift+F8` | n | Jump diagnostics | |

### Integrated terminal

| VSCode | Neovim key | Mode | Action |
|--------|-----------|------|--------|
| Toggle Terminal | `` Ctrl+` `` | n/i/t | Toggle floating terminal |
| (inside terminal) | `Esc Esc` | t | Back to normal mode |

The terminal is a centered floating window (85% × 85%, rounded border). If
`` Ctrl+` `` doesn't fire in your terminal, LazyVim's `<leader>ft` (float) and
`<leader>fT` (full) still work.

---

## Languages

| Language | LSP | Formatter | Source |
|----------|-----|-----------|--------|
| **bash** / shell | bash-language-server | shfmt | `lua/plugins/langs.lua` |
| **python** | basedpyright/pyright + ruff | black/ruff | LazyVim `lang.python` extra |
| **rust** | rust-analyzer (rustaceanvim) | rustfmt | LazyVim `lang.rust` extra + `lua/plugins/rust.lua` |
| **c** | clangd | clang-format¹ | LazyVim `lang.clangd` extra |
| **c++** | clangd | clang-format¹ | LazyVim `lang.clangd` extra |
| **go** | gopls | gofumpt + goimports | LazyVim `lang.go` extra |
| **lua** | lua_ls (+ lazydev) | stylua | LazyVim core |
| **zig** | zls | zig fmt (via zls) | `lua/plugins/langs.lua` |

¹ Autoformat-on-save is currently **off** for `c`/`cpp`/`yaml` (see
`lua/config/autocmds.lua`). Format manually with `Shift+Alt+F`.

All parsers are added to treesitter's `ensure_installed`. Tools install via
Mason on first use — open a file of that type, or run `:Mason`. zls needs a Zig
toolchain on your `PATH`.

---

## Customizing

- Disable a single mapping: comment out its line in `lua/config/keymaps.lua`.
- Don't want full emulation? Remove the **Clipboard**, **Undo/redo**, and
  **Select All** blocks to restore vim's `Ctrl+A`/`Ctrl+V`/`Ctrl+Z` defaults
  (and delete the `+`/`-` increment remap).
-Thanks for the push on the moat. You said a single heuristic engine won't make anyone buy us, and you were right. It sent me back to first principles, and the problem turned out to be bigger and more useful than just the moat.

The honest diagnosis: Vyrox is a feature wearing the costume of a platform. What we actually ship is alert triage that posts to Discord. What we pitch is "runs your SOC 24/7." Triage is also the most crowded part of this market, where we compete against companies with 50 to 1000 times our funding. So we were leading with our weakest hand.

Here is where I am taking it:

- Stop selling triage. Sell the thing that happens after it, which nobody does well: Vyrox acts on alerts, can reverse the action, and produces an owned, tamper-evident record an auditor or cyber insurer will accept.
- New one-liner: the autonomous, auditable action layer that lets one analyst safely act on alerts across many clients and prove every action.
- Change the buyer to MSSPs. They have the analysts, so the "no team" problem disappears. They feel client audit pressure hardest. And the math is margin: AI-augmented MSSP SOCs move from roughly 40 percent to roughly 80 percent gross margin. One MSSP is also a channel to dozens of downstream clients.
- Kill what was hurting us: some invented-looking metrics in our own docs, and the "runs your whole SOC" overclaim. Lead with what is real.

Why it is defensible without claiming our AI is smarter: the read-only players stop at a verdict, the managed players are black boxes, and the EDR vendors will never hand customers a portable audit trail. We act, and we hand over the proof. That is the moat you were asking for, and it doubles as the reason a buyer says yes.

Three things I would value your gut check on:

1. Moving the headline buyer from the no-SOC mid-market to MSSPs. It is a real pivot. Does it ring true for the buyers you know?
2. The endgame is fully autonomous response by 2027, but we start human-in-the-loop to earn the trust data and the audit record. Is that sequencing sound, or do you see a hole?
3. The cyber-insurance angle: an insurer accepting our audit pack toward a premium discount. Strong, or a distraction?

I have written this up as a one-pager and a fuller direction doc. Terminal size/position: edit `win` in `lua/plugins/terminal.lua`.
