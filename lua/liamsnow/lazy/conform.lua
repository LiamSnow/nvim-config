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
          python = { "isort", "black" },
          javascript = { { "prettierd", "prettier" } }, -- sub-list runs first available
          typescript = { { "prettierd", "prettier" } },
          svelte = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          java = { "google-java-format" },
          markdown = { { "prettierd", "prettier" } }, -- "markdownlint"
          html = { "htmlbeautifier" },
          bash = { "beautysh" },
          rust = { "rustfmt" },
          yaml = { "yamlfix" },
          toml = { "taplo" },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
          go = { "goimports", "gofumpt" },
          -- zig = { "zigfmt" },
          c = { "clang-format" },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "isort",
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
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay
      })

      -- overrides from vim.lua
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end
  }
}
