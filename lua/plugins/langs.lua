-- Coding language support: bash, python, rust, c, c++, go, lua, zig.
--
-- Already provided elsewhere:
--   python, rust   -> LazyVim lang extras (lazyvim.json)
--   c, c++         -> clangd extra (lazyvim.json)
--   go             -> lang.go extra (added to lazyvim.json)
--   lua            -> LazyVim core (lua_ls + lazydev)
--
-- This file fills the gaps LazyVim has no extra for: bash (shell) and zig,
-- and makes sure every requested language has a treesitter parser.
return {
  -- Treesitter parsers (idempotent; extends LazyVim's default list)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "c",
        "cpp",
        "go",
        "gomod",
        "gosum",
        "lua",
        "python",
        "rust",
        "zig",
      })
    end,
  },

  -- LSP servers. LazyVim auto-installs these via mason + mason-lspconfig.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {}, -- bash-language-server (sh/bash)
        zls = {}, -- zig language server
      },
    },
  },

  -- Extra Mason tools that aren't LSP servers (e.g. the shell formatter).
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shfmt", -- shell formatter
        "zls",
      })
    end,
  },

  -- Formatting for shell scripts via shfmt.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },
}
