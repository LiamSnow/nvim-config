return {
	{
		"toppair/peek.nvim",
		dir = "~/.config/nvim/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			local peek = require("peek")

			vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
			vim.api.nvim_create_user_command("PeekClose", peek.close, {})

			-- vim.keymap.set("n", "<leader>l", function()
			-- 	if peek.is_open then
			--     peek.setup({ app = "webview" })
			-- 		peek.open()
			-- 	else
			-- 		peek.close()
			-- 	end
			-- end)
			--
			-- vim.keymap.set("n", "<leader><A-l>", function()
			-- 	if peek.is_open then
			--     peek.setup({ app = "firefox" })
			-- 		peek.open()
			-- 	else
			-- 		peek.close()
			-- 	end
			-- end)
			--
			-- vim.keymap.set("n", "<leader><S-l>", peek.close)
		end,
	},
}
