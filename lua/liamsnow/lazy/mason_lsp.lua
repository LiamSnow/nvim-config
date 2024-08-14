return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities())

      require("fidget").setup()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "pyright",
          "cssls",
          "html",
          -- "biome", -- ts, js
          "tsserver",
          "zls",   -- zig
          "yamlls",
          "matlab_ls",
          "svls", -- sys verilog
          "dockerls",
          -- "denols",
          "texlab",
          "clangd",
          "cmake",
          "arduino_language_server",
          "marksman", -- md
          "terraformls",
          -- "hyprls"
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,

          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                    path = vim.split(package.path, ';'),
                  },
                  diagnostics = {
                    globals = { 'vim' },
                  },
                  workspace = {
                    library = {
                      vim.fn.expand('$VIMRUNTIME/lua'),
                      vim.fn.stdpath('config') .. '/lua'
                    },
                  },
                },
              },
            }
          end,

          ["pyright"] = function()
            require("lspconfig").pyright.setup {
              capabilities = capabilities,
              settings = {
                pyright = {
                  autoImportCompletion = true,
                },
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = 'openFilesOnly',
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'off'
                  }
                }
              }
            }
          end
        }
      })
    end
  }
}
