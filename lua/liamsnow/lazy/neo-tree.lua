vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          position = "current",
        },
        filesystem = {
          hijack_netrw_behavior = "open_current",
          filtered_items = {
            visible = true
          }
        },
        default_component_configs = {
          type = {
            enabled = false,
          }
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt.relativenumber = true
            end,
          }
        },
      })

      vim.keymap.set('n', '<leader>e', ':Neotree<CR>')
      vim.keymap.set('n', '<leader><S-e>', ':Neotree toggle<CR>')
    end
  }
}
