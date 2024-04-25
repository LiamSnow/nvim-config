return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
    },

    config = function()
      local cmp = require('cmp')
      local cmp_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())

      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "pyright",
          "cssls",
          "html",
          "biome", -- ts, js
          "zls", -- zig
          "yamlls",
          "matlab_ls",
          "svls", -- sys verilog
          "dockerls",
          "denols",
          "texlab",
          "clangd",
          "cmake",
          "arduino_language_server",
          "marksman" -- md
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

      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<A-,>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<A-.>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-.>'] = cmp.mapping.confirm({ select = true }),
          ["<C-/>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      vim.diagnostic.config({
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end
  }
}
