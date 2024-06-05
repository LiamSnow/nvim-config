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
            bg3 = '#333333',
            bg4 = '#000000',
          }
        }
      })

      vim.cmd("colorscheme carbonfox")

      vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = '#ee5396', bold = true })
      vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = '#25be6a', bold = true })
      vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = '#08bdba', bold = true })
      vim.api.nvim_set_hl(0, '@markup.heading.4.markdown', { fg = '#78a9ff', bold = true })
      vim.api.nvim_set_hl(0, '@markup.heading.5.markdown', { fg = '#be95ff', bold = true })
      vim.api.nvim_set_hl(0, '@markup.heading.6.markdown', { fg = '#33b1ff', bold = true })
    end
  }
}
