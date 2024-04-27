return {
  {
    "LiamSnow/pygpt.nvim",
    dir = "~/.config/nvim/pygpt.nvim",
    lazy = false,
    -- build = function()
      -- vim.cmd([[silent UpdateRemotePlugins]])
    -- end,
    config = function()
      require("pygpt").setup({
        height = 2
      })
    end
  },
}
