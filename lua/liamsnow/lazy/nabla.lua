return {
	{
		"jbyuki/nabla.nvim",
		event = "VeryLazy",
		config = function()
			vim.api.nvim_set_keymap(
				"n",
				"<leader>m",
				'<cmd>lua require("nabla").popup()<CR>',
				{ noremap = true, silent = true, desc = "Nabla latex preview" }
			)
		end,
	},
}
