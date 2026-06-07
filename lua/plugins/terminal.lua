-- Floating integrated terminal, VSCode-style.
-- Toggled with Ctrl+` (see lua/config/keymaps.lua). Snacks.terminal.toggle()
-- with no opts uses these global defaults, so the same key opens/closes it.
-- <Esc><Esc> inside the terminal returns to normal mode (Snacks default).
return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "float",
        border = "rounded",
        backdrop = 60,
        height = 0.85,
        width = 0.85,
        title = " Terminal ",
        title_pos = "center",
      },
    },
  },
}
