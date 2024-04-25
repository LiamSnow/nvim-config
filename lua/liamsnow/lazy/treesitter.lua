return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
          "c", "lua", "vim", "go", "rust", "javascript",
          "html", "css", "python", "bash", "markdown",
          "markdown_inline", "verilog", "java", "comment"
        },
        sync_install = false,
        auto_insall = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
        },
        indent = { enable = true },
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require('treesitter-context').setup({
        enable = true,
      })
    end
  }
}
