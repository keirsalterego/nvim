-- Shared helpers for AI agent terminal panels (Claude, Gemini, OpenCode).
-- Applies a darkened window background so AI panels are visually distinct
-- from regular editor splits without going full black.

local M = {}

-- Returns the current Normal bg darkened to ~60% brightness.
-- Falls back to tokyonight-night's base colour if the hl has no bg set.
function M.darkened_bg()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = hl.bg or 0x1a1b26
  local r = math.floor(math.floor(bg / 65536) * 0.6)
  local g = math.floor(math.floor((bg % 65536) / 256) * 0.6)
  local b = math.floor((bg % 256) * 0.6)
  return r * 65536 + g * 256 + b
end

-- Apply the darkened bg to a given window handle.
function M.apply(win)
  vim.api.nvim_set_hl(0, "AIAgentBg", { bg = M.darkened_bg() })
  vim.wo[win].winhighlight = "Normal:AIAgentBg,NormalNC:AIAgentBg"
end

return M
