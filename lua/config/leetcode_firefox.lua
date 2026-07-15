-- Bridge: sign in to leetcode.nvim using the cookie already stored by Firefox.
--
-- The installed leetcode.nvim only supports pasting a cookie manually. This runs
-- scripts/firefox_leetcode_cookie.py (reads Firefox's cookies.sqlite) and writes
-- the result into the plugin's cookie cache file. On the next :Leet, the plugin's
-- normal startup reads that file and authenticates — no pasting.
--
-- Why write the file directly instead of calling Cookie.set(): the plugin only
-- initialises config.storage.cache inside leetcode.start() (i.e. when :Leet runs),
-- so touching require("leetcode.cache.cookie") beforehand errors. The cache file
-- is just the raw "csrftoken=…; LEETCODE_SESSION=…" string, which is exactly what
-- the extractor produces, so a plain file write is the robust path.
--
-- Wired up in plugins/leetcode.lua:
--   * <leader>plo opens the dashboard, refreshing the cookie from Firefox first
--   * <leader>plf / :LeetFirefox force a refresh (use when the session expires)
local M = {}

local script = vim.fn.stdpath("config") .. "/scripts/firefox_leetcode_cookie.py"

local function notify(msg, level)
  vim.notify(msg, level, { title = "leetcode.nvim ⇠ firefox" })
end

--- Path of the plugin's cookie cache file (honours any storage override).
local function cookie_file()
  local config = require("leetcode.config")
  local cache = (config.user and config.user.storage and config.user.storage.cache)
    or (vim.fn.stdpath("cache") .. "/leetcode")
  cache = vim.fn.expand(cache)
  return cache, cache .. "/cookie" .. (config.is_cn and "_cn" or "")
end

--- Pull the cookie string out of Firefox. Returns (string|nil, err|nil).
function M.cookie()
  if vim.fn.executable("python3") == 0 then
    return nil, "python3 not found on PATH"
  end
  if vim.fn.filereadable(script) == 0 then
    return nil, "extractor missing: " .. script
  end
  local res = vim.system({ "python3", script }, { text = true }):wait()
  if res.code ~= 0 then
    local err = vim.trim(res.stderr or "")
    return nil, err ~= "" and err or "cookie extraction failed"
  end
  local cookie = vim.trim(res.stdout or "")
  if cookie == "" then
    return nil, "no LeetCode cookie found in Firefox"
  end
  return cookie
end

--- Extract from Firefox and write it into the plugin's cookie cache.
--- opts.silent suppresses notifications. Returns true on success.
function M.login(opts)
  opts = opts or {}
  -- Ensure the plugin (and its config defaults) are loaded so we resolve the
  -- right cache path; this runs apply()/setup() only, never the blocking start().
  require("lazy").load({ plugins = { "leetcode.nvim" } })

  local cookie, err = M.cookie()
  if not cookie then
    if not opts.silent then notify(err, vim.log.levels.WARN) end
    return false
  end

  local dir, path = cookie_file()
  vim.fn.mkdir(dir, "p")
  local fh, ferr = io.open(path, "w")
  if not fh then
    if not opts.silent then notify("cannot write " .. path .. ": " .. tostring(ferr), vim.log.levels.ERROR) end
    return false
  end
  fh:write(cookie)
  fh:close()

  if not opts.silent then notify("Firefox cookie applied — verifying on :Leet", vim.log.levels.INFO) end
  return true
end

-- A window we should NOT let leetcode's `enew` take over: floating windows, the
-- snacks explorer/picker, file-tree sidebars, terminals (the AI panels), etc.
local function is_sidebar(win)
  if vim.api.nvim_win_get_config(win).relative ~= "" then
    return true -- floating
  end
  if vim.wo[win].winfixwidth then
    return true -- pinned-width sidebar
  end
  local buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[buf].filetype
  if ft:match("^snacks_") or ft == "neo-tree" or ft == "NvimTree" or ft == "aerial" then
    return true
  end
  local bt = vim.bo[buf].buftype
  return bt == "terminal" or bt == "prompt" or bt == "quickfix"
end

-- leetcode.start() runs `enew` in the current window, so if focus is in the
-- explorer/sidebar the dashboard renders there. Move to a real editor window
-- (or make one) before opening.
function M.focus_editor_window()
  if not is_sidebar(vim.api.nvim_get_current_win()) then
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not is_sidebar(win) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.cmd("botright vsplit") -- no editor window exists; create one
end

--- Open the LeetCode dashboard, refreshing the cookie from Firefox first so the
--- session always tracks your current Firefox login (auto-recovers on expiry).
--- A failed extraction is non-fatal: we still open and fall back to whatever
--- cookie is already cached (or the plugin's manual sign-in page).
function M.open()
  M.login({ silent = true })
  M.focus_editor_window()
  vim.cmd("Leet")
end

return M
