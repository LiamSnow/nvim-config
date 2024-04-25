return {
  "norcalli/nvim-colorizer.lua",
  lazy = false,
  config = function()
    require("colorizer").setup(
      {
        'css', 'javascript', 'typescript', 'html',
        'lua', 'markdown'
      }, {
        RGB      = true,
        RRGGBB   = true,
        names    = true,
        RRGGBBAA = true,
        rgb_fn   = true,
        hsl_fn   = true,
        css      = true,
        css_fn   = true,
        mode     = 'background',
      }
    )
  end
}
