return {
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.g.lazyvim_rust_diagnostics = "bacon-ls"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        on_attach = function(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = false,
              loadOutDirsFromCheck = false,
              buildScripts = {
                enable = true, -- Anchor/protocol crates: RA must run build scripts
              },
            },
            checkOnSave = false,
            diagnostics = {
              enable = false,
            },
            procMacro = {
              enable = true, -- #[program] / #[derive(Accounts)] need macro expansion
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        exclude = { "rust", "vue" },
      },
    },
  },
}
