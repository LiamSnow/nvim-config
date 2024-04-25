return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          preview = {
            filesize_limit = 0.1, -- MB
          },
        }
      })

      local builtin = require('telescope.builtin')

      -- Always search files
      vim.keymap.set('n', '<leader><S-p>', builtin.find_files, {})

      -- Search git with files as fallback
      vim.keymap.set('n', '<leader>p', function()
        local ok = pcall(builtin.git_files)
        if not ok then
          builtin.find_files()
        end
      end, {})

      vim.keymap.set('n', '<leader>gws', function()
        local word = vim.fn.expand("<cword>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>gWs', function()
        local word = vim.fn.expand("<cWORD>")
        builtin.grep_string({ search = word })
      end)
      vim.keymap.set('n', '<leader>gs', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)
      vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
  },
  --  {
  --    'nvim-telescope/telescope-ui-select.nvim',
  --    config = function()
  --      require("telescope").setup({
  --        extensions = {
  --          ["ui-select"] = {
  --            require("telescope.themes").get_dropdown {}
  --          }
  --        }
  --      })
  --      require("telescope").load_extension("ui-select")
  --    end
  --  }
}
