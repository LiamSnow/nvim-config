return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- Recommended
	-- ft = "markdown" -- If you decide to lazy-load anyway

	dependencies = {
		-- You will not need this if you installed the
		-- parsers manually
		-- Or if the parsers are in your $RUNTIMEPATH
		"nvim-treesitter/nvim-treesitter",

		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local presets = require("markview.presets")
		local colors = require("markview.colors")

		require("markview").setup({
			modes = { "n", "no", "c" }, -- Change these modes
			-- to what you need

			hybrid_modes = { "n" }, -- Uses this feature on
			-- normal mode

			-- This is nice to have
			callbacks = {
				on_enable = function(_, win)
					vim.wo[win].conceallevel = 2
					vim.wo[win].conecalcursor = "c"
				end,
			},

			-- highlight_groups = {
			-- 	{
			-- 		group_name = "MarkviewCode",
			-- 		value = {
   --          bg = "#ff000000",
   --          default = true
   --        },
			-- 	},
			-- },

			code_blocks = {
				style = "language",
				icons = true,
				position = nil,
				min_width = 70,

				pad_amount = 3,
				pad_char = " ",

				language_direction = "right",
				language_names = {},

				sign = true,
				sign_hl = nil,
			},

			-- headings = {
			-- 	enable = true,
			-- 	shift_width = 1,
			-- },
			headings = presets.headings.glow_labels,
		})
	end,
}
