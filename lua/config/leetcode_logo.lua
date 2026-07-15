-- Replace leetcode.nvim's hardcoded menu logo with a KEIR-style "LEETCODE"
-- banner (same ANSI Shadow block font as the snacks dashboard header).
--
-- leetcode.nvim has no logo option — the art is baked into the module
-- leetcode-ui.lines.menu-header, which every dashboard page require()s at the
-- top. We build an equivalent Lines object and pre-seed package.loaded so those
-- requires return ours. Done in the plugin's config() (before the first :Leet
-- builds any page), so it's update-safe: no plugin file is edited.
local M = {}

-- "LEETCODE" in ANSI Shadow (matches lua/plugins/dashboard.lua).
local art = {
  [[██╗     ███████╗███████╗████████╗ ██████╗ ██████╗ ██████╗ ███████╗]],
  [[██║     ██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔═══██╗██╔══██╗██╔════╝]],
  [[██║     █████╗  █████╗     ██║   ██║     ██║   ██║██║  ██║█████╗  ]],
  [[██║     ██╔══╝  ██╔══╝     ██║   ██║     ██║   ██║██║  ██║██╔══╝  ]],
  [[███████╗███████╗███████╗   ██║   ╚██████╗╚██████╔╝██████╔╝███████╗]],
  [[╚══════╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝]],
}

function M.apply()
  local ok, Lines = pcall(require, "leetcode-ui.lines")
  if not ok then
    return
  end

  local Header = Lines:extend("KeirLeetHeader")
  function Header:init()
    Header.super.init(self, {}, { hl = "Keyword" })
    for _, line in ipairs(art) do
      self:append(line):endl()
    end
  end

  -- Pre-seed the module cache so every page's require() returns our banner.
  package.loaded["leetcode-ui.lines.menu-header"] = Header()
end

return M
