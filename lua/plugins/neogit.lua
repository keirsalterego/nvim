return {
  "TimUntersberger/neogit",
  dependencies = {
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",
  },
  config = function()
    require("neogit").setup()
  end,
}
