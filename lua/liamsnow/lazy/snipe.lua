return {
	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"<leader>v",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open Snipe buffer menu",
			},
		},
		opts = {
            ui = {
                -- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
                position = "center"
            }
        },
	},
}
