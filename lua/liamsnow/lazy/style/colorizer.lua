return {
	"norcalli/nvim-colorizer.lua",
	lazy = false,
	config = function()
		require("colorizer").setup({ "*" }, {
			RGB = true,
			RRGGBB = true,
			names = false,
			RRGGBBAA = true,
			rgb_fn = true,
			hsl_fn = true,
			css = true,
			css_fn = true,
			mode = "background",
		})
	end,
}
