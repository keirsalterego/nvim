-- Exercism inside Neovim — 2KAbhishek/exercism.nvim
-- A thin wrapper around the `exercism` CLI, so that must be installed and
-- configured first (see the note at the bottom of this file).
--
-- We disable the plugin's built-in keybindings (add_default_keybindings) because
-- they live under <leader>ex*, which collides with LazyVim's <leader>e
-- (explorer). Instead everything hangs off the shared <leader>pe* "practice"
-- group defined below, alongside the LeetCode maps in plugins/leetcode.lua.
--
-- default_language is "rust" (primary language); browse any track with
-- :Exercism languages or <leader>pea. exercism_workspace must match the path
-- the CLI uses — check it with `exercism workspace`.
--
-- Serial order: :Exercism list is overridden (config/exercism_order.lua) to show
-- exercises numbered 1,2,3… in learning order (hello-world → concepts → practice
-- easiest-first) with a difficulty marker, reading ordered data from
-- ~/.config/nvim/exercism-data. Refresh that data with :ExercismRegen.
return {
  {
    "2KAbhishek/exercism.nvim",
    cmd = "Exercism",
    dependencies = {
      "2KAbhishek/utils.nvim",
      "2KAbhishek/termim.nvim", -- nicer UX for running tests in a terminal
    },
    init = function()
      vim.api.nvim_create_user_command("ExercismRegen", function(o)
        require("config.exercism_order").regen(o.fargs)
      end, { nargs = "*", desc = "Regenerate ordered Exercism lists (optionally pass track names)" })
    end,
    config = function(_, opts)
      require("exercism").setup(opts)
      require("config.exercism_order").patch() -- numbered, ordered :Exercism list
    end,
    keys = {
      { "<leader>pea", "<cmd>Exercism languages<cr>", desc = "Exercism: Languages" },
      { "<leader>pel", "<cmd>Exercism list<cr>", desc = "Exercism: List exercises" },
      { "<leader>per", "<cmd>Exercism recents<cr>", desc = "Exercism: Recent exercises" },
      { "<leader>pet", "<cmd>Exercism test<cr>", desc = "Exercism: Test" },
      { "<leader>pes", "<cmd>Exercism submit<cr>", desc = "Exercism: Submit" },
    },
    opts = {
      exercism_workspace = "~/exercism",
      default_language = "rust",
      add_default_keybindings = false,
    },
  },
  -- which-key group label for the exercism submenu (<leader>p comes from leetcode.lua)
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>pe", group = "exercism" },
      },
    },
  },
}
