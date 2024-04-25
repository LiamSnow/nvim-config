return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false,
          terminal_colors = true
        },
        palettes = {
          carbonfox = {
            bg0 = '#000000',
            bg1 = '#000000',
            bg2 = '#000000',
            bg3 = '#000000',
            bg4 = '#000000',
          }
        }
      })

      vim.cmd("colorscheme carbonfox")
    end
  }
}
