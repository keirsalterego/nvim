-- Web3 / EVM development support.
--
-- Solana is ALREADY covered by existing extras, nothing to add for it:
--   Anchor/native programs -> lang.rust extra (rust-analyzer, rustaceanvim)
--   Anchor.toml / Cargo.toml -> lang.toml extra
--   program IDLs            -> lang.json extra
--   dApp frontends (@solana/kit, web3.js) -> lang.typescript + biome extras
--
-- The only real gap is Solidity (EVM: Ethereum, Base, Arbitrum, ...). This
-- file fills it, mirroring the pattern in langs.lua.
return {
  -- Treesitter parser for .sol
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "solidity" })
    end,
  },

  -- Solidity LSP: Nomic Foundation (Hardhat) server — the most complete one.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solidity_ls_nomicfoundation = {},
      },
    },
  },

  -- Auto-install the LSP via Mason.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "nomicfoundation-solidity-language-server" })
    end,
  },

  -- Formatting via `forge fmt`. ponytail: needs Foundry (`foundryup`); if it's
  -- not installed conform just reports the formatter missing, no crash. Swap to
  -- { "prettier" } if you use prettier-plugin-solidity instead.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        solidity = { "forge_fmt" },
      },
    },
  },
}
