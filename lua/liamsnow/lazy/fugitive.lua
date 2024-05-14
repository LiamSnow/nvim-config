return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<A-g>", vim.cmd.Git)

			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "*",
				callback = function()
					if vim.bo.ft ~= "fugitive" then
						return
					end

					local opts = {
            buffer = vim.api.nvim_get_current_buf(),
            remap = false
          }

					vim.keymap.set("n", "<leader>p", function()
						vim.cmd.Git("push")
					end, opts)

					vim.keymap.set("n", "<leader>P", function()
            -- rebase on top 🙌
						vim.cmd.Git({ "pull", "--rebase" })
					end, opts)
				end,
			})

			vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
			vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
		end,
	},
}
