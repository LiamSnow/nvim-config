return {
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"<leader>0",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open Snipe buffer menu",
			},
		},
		opts = {},
	},
}
