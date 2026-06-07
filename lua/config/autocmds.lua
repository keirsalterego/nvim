-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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
