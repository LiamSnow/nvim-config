return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "go",
          "rust",
          "javascript",
          "html",
          "css",
          "python",
          "bash",
          "markdown",
          "markdown_inline",
          "verilog",
          "java",
          "comment",
          "arduino",
          "cmake",
          "csv",
          "dockerfile",
          "json",
          "matlab",
          "regex",
          "toml",
          "typescript",
          "xml",
          "zig",
          "yaml",
          "latex",
          -- "terraform",
          "swift",
          "hyprlang",
          -- "rasi",
          -- "glimmer",
          -- "templ",
          -- "svelte",
          "typst",
          -- "gleam",
          "ron",
          -- "elm",
          -- "rescript",
          -- "asm",
          "lalrpop"
        },
        sync_install = false,
        auto_insall = true,
         highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },
          custom_captures = {
            ["text.title.1.markdown"] = "MarkdownH1",
            ["text.title.2.markdown"] = "MarkdownH2",
            ["text.title.3.markdown"] = "MarkdownH3",
            ["text.title.4.markdown"] = "MarkdownH4",
            ["text.title.5.markdown"] = "MarkdownH5",
            ["text.title.6.markdown"] = "MarkdownH6",
          },
        },
        indent = { enable = false },
      })

      vim.filetype.add({
        extension = {
          handlebars = "glimmer",
        },
      })
    end
  },
  -- Has been causing lots of random issues -- disabling for now
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   config = function()
  --     require('treesitter-context').setup({
  --       enable = true,
  --     })
  --   end
  -- }
  {
    'isobit/vim-caddyfile'
  }
}
