
local function light()
    vim.api.nvim_set_option_value("background", "light", {})
    vim.cmd([[colorscheme tokyonight-day]])
end

local function dark()
    vim.api.nvim_set_option_value("background", "dark", {})
    vim.cmd([[colorscheme tokyonight-night]])

    -- lines
    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#f5deb3" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "orange", bold = true })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#f5deb3" })

    -- cursor line
    -- vim.api.nvim_set_hl(0, "CursorLine", { guibg = "#333333" })
    -- vim.api.nvim_set_hl(0, "CursorLine", { underline = true, reverse = true })
end

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

            dark()
		end,
	},
	-- {
	-- 	"f-person/auto-dark-mode.nvim",
	-- 	opts = {
	-- 		set_dark_mode = function()
 --                dark()
	-- 		end,
	-- 		set_light_mode = function()
 --                light()
	-- 		end,
	-- 		update_interval = 200,
	-- 		fallback = "dark",
	-- 	},
	-- },
}
