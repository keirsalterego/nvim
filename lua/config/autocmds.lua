-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ---------------------------------------------------------------------------
-- AI agent terminal panels (Gemini, OpenCode)
-- Claude Code has its own autocmd in lua/plugins/claude-code.lua.
-- All three share the same darkened-bg logic via config.ai_panel.
-- ---------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("ai_agent_panels", { clear = true }),
  callback = function(ev)
    if vim.bo[ev.buf].buftype ~= "terminal" then
      return
    end
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if not (name:match("gemini") or name:match("opencode") or name:match("open%-code")) then
      return
    end
    local win = vim.fn.bufwinid(ev.buf)
    if win ~= -1 then
      require("config.ai_panel").apply(win)
    end
  end,
})

-- Autoformat setting
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

set_autoformat({ "cpp" }, false)
set_autoformat({ "c" }, false)
set_autoformat({ "yaml" }, false)

-- Per-language indentation
local indent = {
  python = { sw = 4, ts = 4 },
  bash = { sw = 2, ts = 2 },
  sh = { sw = 2, ts = 2 },
  zig = { sw = 4, ts = 4 },
  php = { sw = 4, ts = 4 },
  haskell = { sw = 2, ts = 2 },
  rust = { sw = 4, ts = 4 },
  lua = { sw = 2, ts = 2 },
  json = { sw = 2, ts = 2 },
  yaml = { sw = 2, ts = 2 },
  toml = { sw = 2, ts = 2 },
  cmake = { sw = 2, ts = 2 },
  nushell = { sw = 2, ts = 2 },
  markdown = { sw = 2, ts = 2 },
  tex = { sw = 4, ts = 4 },
  sql = { sw = 4, ts = 4 },
  dockerfile = { sw = 4, ts = 4 },
  javascript = { sw = 2, ts = 2 },
  typescript = { sw = 2, ts = 2 },
  vue = { sw = 2, ts = 2 },
  twig = { sw = 2, ts = 2 },
  css = { sw = 2, ts = 2 },
  tailwind = { sw = 2, ts = 2 },
  typst = { sw = 2, ts = 2 },
}

local indent_tabs = {
  go = { sw = 8, ts = 8 },
  make = {},
  c = { sw = 4, ts = 4 },
  cpp = { sw = 4, ts = 4 },
}

for ft, cfg in pairs(indent) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      vim.bo.shiftwidth = cfg.sw
      vim.bo.tabstop = cfg.ts
      vim.bo.softtabstop = cfg.ts
      vim.bo.expandtab = true
    end,
  })
end

for ft, cfg in pairs(indent_tabs) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      vim.bo.shiftwidth = cfg.sw or 8
      vim.bo.tabstop = cfg.ts or 8
      vim.bo.softtabstop = 0
      vim.bo.expandtab = false
    end,
  })
end

-- ---------------------------------------------------------------------------
-- Autosave (VSCode-style)
-- ---------------------------------------------------------------------------
-- Automatically saves the buffer when focus is lost, when leaving a buffer,
-- or when exiting insert mode. Only triggers for normal files with names.
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.api.nvim_command("silent! update")
    end
  end,
})
