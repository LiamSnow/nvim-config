return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim'
    },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { { "prettierd", "prettier" } }, -- sub-list runs first available
          typescript = { { "prettierd", "prettier" } },
          svelte = { { "prettierd", "prettier" } },
          java = { "google-java-format" },
          markdown = { { "prettierd", "prettier" } }, -- "markdownlint"
          html = { "htmlbeautifier" },
          bash = { "beautysh" },
          rust = { "rustfmt" },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
          rasi = { { "prettierd", "prettier" } },
          go = { "goimports", "gofumpt" },
          -- zig = { "zigfmt" },
          c = { "clang-format" },

          yaml = { "yamlfix" },
          json = { { "prettierd", "prettier" } },
          toml = { "taplo" },
          xml = { "yq" },
          csv = { "yq" },
          jsonc = { "deno_fmt" },
          typst = { "typstyle" },
          gleam = { "gleam" },
          rescript = { "rescript-format" },
          elm = { "elm_format" },
        },
        formatters = {
          black = {
            prepend_args = { "--fast" },
          }
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "black",
          "prettierd",
          "prettier",
          "google-java-format",
          "htmlbeautifier",
          "beautysh",
          "rustfmt",
          "yamlfix",
          "taplo",
          "goimports",
          "gofumpt",
          -- "zigfmt",
          "clang-format",
        },
        auto_update = true,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay
      })

      -- overrides from vim.lua
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = true,
          timeout_ms = 5000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end
  }
}
