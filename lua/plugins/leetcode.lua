-- LeetCode inside Neovim — kawre/leetcode.nvim
-- Lazy-loaded on the :Leet command and the <leader>pl* keys below.
--
-- Picker: leetcode.nvim auto-resolves the first available provider in the
-- order snacks-picker > fzf-lua > telescope > mini. This config ships
-- snacks_picker, so it resolves to snacks-picker; we set it explicitly so the
-- choice is deterministic if extras change later.
--
-- Language: defaults to "cpp" (matches the C++-for-DSA/interviews workflow).
-- Change opts.lang to "rust", "python3", etc. or switch live with :Leet lang.
--
-- Sign-in: leetcode.nvim has no web login (LeetCode exposes no OAuth/API), so it
-- authenticates with your leetcode.com session cookie. We pull that cookie
-- straight from Firefox — <leader>plo (open) auto-signs-in on first use, and
-- <leader>plf / :LeetFirefox refresh it when the session expires. The bridge is
-- config/leetcode_firefox.lua + scripts/firefox_leetcode_cookie.py.
return {
  {
    "kawre/leetcode.nvim",
    -- NOTE: the upstream README's `build = ":TSUpdate html"` only works on the
    -- legacy treesitter (master). This config uses nvim-treesitter `main`, where
    -- that command signature is gone, so we install the html parser (needed to
    -- render problem descriptions) via LazyVim's ensure_installed below instead.
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      vim.api.nvim_create_user_command("LeetFirefox", function()
        require("config.leetcode_firefox").login()
      end, { desc = "Sign in to LeetCode using the Firefox cookie" })
    end,
    config = function(_, opts)
      require("leetcode").setup(opts)
      -- Swap leetcode's logo for the KEIR-style "LEETCODE" banner. Must run
      -- after the plugin loads (leetcode-ui is available) but before the first
      -- :Leet renders a page — config() satisfies both.
      require("config.leetcode_logo").apply()
    end,
    keys = {
      { "<leader>plo", function() require("config.leetcode_firefox").open() end, desc = "LeetCode: Dashboard (Firefox login)" },
      { "<leader>plf", function() require("config.leetcode_firefox").login() end, desc = "LeetCode: Sign in via Firefox cookie" },
      { "<leader>pll", "<cmd>Leet list<cr>", desc = "LeetCode: Problem list" },
      { "<leader>plr", "<cmd>Leet run<cr>", desc = "LeetCode: Run" },
      { "<leader>pls", "<cmd>Leet submit<cr>", desc = "LeetCode: Submit" },
      { "<leader>plc", "<cmd>Leet console<cr>", desc = "LeetCode: Console" },
      { "<leader>pld", "<cmd>Leet desc<cr>", desc = "LeetCode: Toggle description" },
      { "<leader>pli", "<cmd>Leet info<cr>", desc = "LeetCode: Info" },
      { "<leader>plD", "<cmd>Leet daily<cr>", desc = "LeetCode: Daily question" },
    },
    opts = {
      lang = "cpp",
      picker = { provider = "snacks-picker" },
      -- Store solution files in ~/leetcode (default is ~/.local/share/nvim/leetcode).
      -- Only `home` moves; `cache` (cookie/session) stays under ~/.cache/nvim.
      storage = { home = "~/leetcode" },
    },
  },
  -- html parser for rendering LeetCode problem descriptions (replaces the
  -- broken `build = ":TSUpdate html"`); LazyVim installs ensure_installed on the
  -- nvim-treesitter `main` branch.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "html" } },
  },
  -- which-key group labels for the practice menu
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "practice" },
        { "<leader>pl", group = "leetcode" },
      },
    },
  },
}
