-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- ============================================================================
--  VSCode-style keymap layer (full emulation)
-- ============================================================================
-- See VSCODE-KEYMAPS.md (repo root) for the full reference + terminal caveats.
--
-- Notes:
--   * Ctrl+Shift+* and Ctrl+. / Ctrl+` only work in terminals that speak the
--     kitty keyboard protocol / CSI-u (kitty, wezterm, ghostty, foot, neovide,
--     recent alacritty). In other terminals Shift is dropped for letters.
--   * Number increment/decrement (was <C-a>/<C-x>) moved to + / -.
--   * Block-visual (was <C-v>) moved to <C-q> (a built-in vim alias).
--   * Window navigation stays on <C-h/j/k/l>; <C-w> now closes the buffer.

local map = vim.keymap.set

-- Resolve diagnostic jump across Neovim versions (0.11 has vim.diagnostic.jump).
local function diag_jump(count)
  return function()
    if vim.diagnostic.jump then
      vim.diagnostic.jump({ count = count, float = true })
    else
      local fn = count > 0 and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
      fn()
    end
  end
end

-- ---------------------------------------------------------------------------
-- Files, search & command palette  (Snacks picker)
-- ---------------------------------------------------------------------------
map({ "n", "i", "v" }, "<C-p>", function() Snacks.picker.files() end, { desc = "Quick Open (Files)" })
map({ "n", "i", "v" }, "<C-S-p>", function() Snacks.picker.commands() end, { desc = "Command Palette" })
map({ "n", "i", "v" }, "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Search in Files" })
map({ "n", "i", "v" }, "<C-S-h>", function() require("grug-far").open() end, { desc = "Replace in Files" })
map("n", "<C-S-o>", function() Snacks.picker.lsp_symbols() end, { desc = "Go to Symbol in File" })
map("n", "<C-t>", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Go to Symbol in Workspace" })

-- Go to line (Ctrl+G)
map({ "n", "i" }, "<C-g>", function()
  vim.ui.input({ prompt = "Go to line: " }, function(input)
    local n = tonumber(input)
    if n then
      n = math.max(1, math.min(n, vim.api.nvim_buf_line_count(0)))
      vim.api.nvim_win_set_cursor(0, { n, 0 })
    end
  end)
end, { desc = "Go to Line" })

-- ---------------------------------------------------------------------------
-- Sidebar / explorer
-- ---------------------------------------------------------------------------
map({ "n", "i" }, "<C-b>", function() Snacks.explorer() end, { desc = "Toggle Sidebar (Explorer)" })
map("n", "<C-S-e>", function() Snacks.explorer() end, { desc = "Explorer" })

-- ---------------------------------------------------------------------------
-- Editor (buffer/tab) management
-- ---------------------------------------------------------------------------
map("n", "<C-w>", function() Snacks.bufdelete() end, { desc = "Close Editor" })
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-\\>", "<cmd>vsplit<cr>", { desc = "Split Editor" })
map({ "n", "i" }, "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Editor" })
map({ "n", "i" }, "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Editor" })
map({ "n", "i" }, "<C-PageDown>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Editor" })
map({ "n", "i" }, "<C-PageUp>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Editor" })

-- Navigate back / forward through the jump list
map("n", "<A-Left>", "<C-o>", { desc = "Navigate Back" })
map("n", "<A-Right>", "<C-i>", { desc = "Navigate Forward" })

-- ---------------------------------------------------------------------------
-- Save
-- ---------------------------------------------------------------------------
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr>", { desc = "Save File" })

-- ---------------------------------------------------------------------------
-- Undo / redo
-- ---------------------------------------------------------------------------
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("v", "<C-z>", "<esc>u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })
map("n", "<C-S-z>", "<C-r>", { desc = "Redo" })

-- ---------------------------------------------------------------------------
-- Clipboard (system clipboard is the default register; see options.lua)
-- ---------------------------------------------------------------------------
map("n", "<C-c>", "yy", { desc = "Copy Line" })
map("v", "<C-c>", "y", { desc = "Copy" })
map("n", "<C-x>", "dd", { desc = "Cut Line" })
map("v", "<C-x>", "d", { desc = "Cut" })
map("n", "<C-v>", "p", { desc = "Paste" })
map("v", "<C-v>", '"_dP', { desc = "Paste over Selection" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste" })
map("c", "<C-v>", "<C-r>+", { desc = "Paste" })

-- Select all
map({ "n", "i" }, "<C-a>", "<esc>ggVG", { desc = "Select All" })

-- Increment / decrement numbers (moved off <C-a>/<C-x>, provided by dial.nvim)
map({ "n", "x" }, "+", "<Plug>(dial-increment)", { desc = "Increment" })
map({ "n", "x" }, "-", "<Plug>(dial-decrement)", { desc = "Decrement" })

-- ---------------------------------------------------------------------------
-- Find / replace within the current file
-- ---------------------------------------------------------------------------
map("n", "<C-f>", "/", { desc = "Find in File" })
map("i", "<C-f>", "<C-o>/", { desc = "Find in File" })
map("v", "<C-h>", ":s/", { desc = "Replace in Selection" })

-- Change-word-and-repeat (closest native equivalent to VSCode Ctrl+D).
-- Selects the word under the cursor; type the replacement, <Esc>, then
-- `.` to change the next match or `n` to skip it.
map("n", "<C-d>", "*Ncgn", { desc = "Change Word (repeat with . / skip with n)" })
map("v", "<C-d>", [[y/\V<C-r>=escape(@", '/\')<cr><cr>Ncgn]], { desc = "Change Selection (repeat with .)" })

-- ---------------------------------------------------------------------------
-- Comment (Ctrl+/) — mini.comment provides gcc / gc
-- ---------------------------------------------------------------------------
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle Comment" })
map("x", "<C-/>", "gc", { remap = true, desc = "Toggle Comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle Comment" })
map("x", "<C-_>", "gc", { remap = true, desc = "Toggle Comment" })

-- ---------------------------------------------------------------------------
-- Move / copy / delete lines
-- ---------------------------------------------------------------------------
-- Move
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Lines Down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Lines Up" })
-- Copy (Shift+Alt+Up/Down)
map("n", "<A-S-Down>", "<cmd>t .<cr>", { desc = "Copy Line Down" })
map("n", "<A-S-Up>", "<cmd>t .-1<cr>", { desc = "Copy Line Up" })
map("v", "<A-S-Down>", ":t '><cr>gv", { desc = "Copy Lines Down" })
map("v", "<A-S-Up>", ":t '<-1<cr>gv", { desc = "Copy Lines Up" })
-- Delete (Ctrl+Shift+K)
map("n", "<C-S-k>", "dd", { desc = "Delete Line" })
map("i", "<C-S-k>", "<esc>ddi", { desc = "Delete Line" })
-- Insert line below / above (Ctrl+Enter / Ctrl+Shift+Enter)
map("i", "<C-cr>", "<esc>o", { desc = "Insert Line Below" })
map("i", "<C-S-cr>", "<esc>O", { desc = "Insert Line Above" })

-- ---------------------------------------------------------------------------
-- Indent / outdent
-- ---------------------------------------------------------------------------
map("v", "<Tab>", ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent" })
map("n", "<C-]>", ">>", { desc = "Indent Line" })

-- Delete word (insert mode)
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Left" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete Word Right" })

-- Toggle word wrap (Alt+Z)
map("n", "<A-z>", "<cmd>set wrap!<cr>", { desc = "Toggle Word Wrap" })

-- ---------------------------------------------------------------------------
-- Code navigation & LSP
-- ---------------------------------------------------------------------------
map("n", "<F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition" })
map("n", "<S-F12>", function() Snacks.picker.lsp_references() end, { desc = "Go to References" })
map("n", "<C-F12>", function() Snacks.picker.lsp_implementations() end, { desc = "Go to Implementation" })
map("n", "<A-F12>", function() Snacks.picker.lsp_definitions() end, { desc = "Peek Definition" })
map({ "n", "x" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Quick Fix / Code Action" })

-- Rename symbol (F2) — uses inc-rename for live preview
map("n", "<F2>", function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename Symbol" })

-- Format document (Shift+Alt+F)
map({ "n", "x" }, "<A-S-f>", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format Document" })

-- ---------------------------------------------------------------------------
-- Problems / diagnostics
-- ---------------------------------------------------------------------------
map("n", "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems Panel" })
map("n", "<F8>", diag_jump(1), { desc = "Next Problem" })
map("n", "<S-F8>", diag_jump(-1), { desc = "Previous Problem" })

-- ---------------------------------------------------------------------------
-- Integrated terminal (Ctrl+`) — floating, configured in plugins/terminal.lua
-- ---------------------------------------------------------------------------
map({ "n", "i", "t" }, "<C-`>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
