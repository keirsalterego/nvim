-- Claude Code CLI integration (greggh/claude-code.nvim).
-- Runs the `claude` CLI in a Neovim terminal panel that auto-refreshes
-- open buffers when Claude edits files on disk.
--
-- Layout: vertical panel docked to the right edge, full height — like the
-- VSCode Copilot chat sidebar. `split_ratio` controls its WIDTH here (a
-- vertical split resizes by columns, not lines).
--
-- Keys:
--   <C-,>        Toggle Claude Code (works in normal AND terminal mode)
--   <leader>ac   Toggle Claude Code
--   <leader>cC   Toggle with --continue (resume most recent conversation)
--   <leader>cV   Toggle with --verbose
-- Commands:
--   :ClaudeCode  :ClaudeCodeContinue  :ClaudeCodeResume  :ClaudeCodeVerbose
--
-- Requires the `claude` CLI on PATH (installed: ~/.local/bin/claude).
return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- already installed; used for git-root detection
  },
  cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
  keys = {
    { "<C-,>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Code (continue)" },
    { "<leader>cV", "<cmd>ClaudeCodeVerbose<cr>", desc = "Claude Code (verbose)" },
  },
  opts = {
    window = {
      split_ratio = 0.35, -- fraction of total WIDTH for the side panel (~35%)
      position = "botright vertical", -- right-docked, full-height vertical panel (VSCode Copilot style)
      enter_insert = true,
      hide_numbers = true,
      hide_signcolumn = true,
    },
    refresh = {
      enable = true, -- reload buffers when Claude edits files on disk
      updatetime = 100,
      timer_interval = 1000,
      show_notifications = true,
    },
    git = {
      use_git_root = true, -- launch claude from the repo root
    },
    command = "claude",
  },
  config = function(_, opts)
    require("claude-code").setup(opts)

    -- Make the Claude Code panel behave like the VSCode Copilot chat sidebar:
    -- a single, fixed, right-docked panel that never duplicates and keeps its
    -- width when you open/close other windows.
    --
    -- Fires on every open (initial creation AND toggle-reopen). Guarded to the
    -- Claude *terminal* buffer only, so it never touches your other terminals
    -- (Gemini, the integrated shell) or your own claude-code.lua file.
    -- TermOpen fires at initial creation (name/buftype are final by then);
    -- BufWinEnter fires on every toggle-reopen. Listening to both keeps the
    -- panel pinned in all cases.
    vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
      group = vim.api.nvim_create_augroup("claude_code_panel", { clear = true }),
      callback = function(ev)
        if vim.bo[ev.buf].buftype ~= "terminal" then
          return
        end
        if not vim.api.nvim_buf_get_name(ev.buf):match("claude") then
          return
        end

        -- 1. Keep it OUT of the listed-buffer set. greggh/claude-code.nvim
        --    opens the panel with `:terminal` (a *listed* buffer) and only sets
        --    bufhidden=hide. While listed, closing other files with
        --    Snacks.bufdelete() (the <C-w> mapping) preserves the window layout
        --    and refills each emptied window with the most-recently-used listed
        --    buffer — the Claude terminal. Close every file and all splits
        --    collapse onto that one buffer, so the panel looks "duplicated".
        --    Unlisting makes Snacks.bufdelete() skip it (it filters buflisted=1)
        --    and hand emptied windows a fresh scratch buffer instead. It also
        --    drops the panel from the bufferline tabs. Toggle is unaffected: the
        --    plugin tracks the panel by buffer number, not by listed state.
        vim.bo[ev.buf].buflisted = false

        -- 2. Pin the panel's width so opening other splits or <C-w>= can't
        --    shrink/grow it, and hard-lock the buffer to the window so nothing
        --    can replace it (true VSCode-sidebar behaviour). The one trade-off
        --    of winfixbuf: if this panel is your last/only window and you open a
        --    file, you'll get "E1513: cannot switch buffer" — open it in another
        --    split instead.
        local win = vim.fn.bufwinid(ev.buf)
        if win ~= -1 then
          vim.wo[win].winfixwidth = true
          if vim.fn.exists("&winfixbuf") == 1 then
            vim.wo[win].winfixbuf = true
          end
          require("config.ai_panel").apply(win)
        end
      end,
    })
  end,
}
