return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			vim.cmd([[colorscheme tokyonight]])

			vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#f5deb3" })
      vim.api.nvim_set_hl(0, 'LineNr', { fg='orange', bold=true })
			vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#f5deb3" })
		end,
	},
}
