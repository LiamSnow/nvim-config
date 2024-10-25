local function read_api_key(key)
	local file = io.open(os.getenv("HOME") .. "/." .. key, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content:gsub("\n", "")
	end
	return ""
end

local anthropic_key = read_api_key("anthropic")
local openai_key = read_api_key("openai")

return {
	{
		"LiamSnow/pygpt.nvim",
		dir = "~/.config/nvim/pygpt.nvim",
		lazy = false,
		build = function()
			vim.cmd([[silent UpdateRemotePlugins]])
		end,
		config = function()
			require("pygpt").setup({
				anthropic_key = anthropic_key,
				openai_key = openai_key,
				default_params = {
					temperature = 0.2,
					max_tokens = 1024,
					system = "You are a knowledgeable, efficient, and direct AI assistant. Offer suggestions tactfully when appropriate to improve outcomes. Engage in productive collaboration with the user utilising multi-step reasoning to answer the question until you are 95% condient in the answer. If there are multiple questions in the initial question split them up and answer them in the order that will provide the most accurate response. Specify if you are not at least 95% confident in your response. Format in Markdown."
				},
			})

			vim.keymap.set({ "n", "v" }, "<C-=>", ":PyGPTToggle<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->", ":PyGPTNew<CR>")

			vim.keymap.set("v", "<C-j>", ":PyGPTRun<CR>")
			vim.keymap.set("n", "<C-A-j>", ":PyGPTStop<CR>")

			vim.keymap.set("n", "<C-A-=>", ":PyGPTExplorer<CR>")

			-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			-- 	callback = function()
			-- 		local bufnr = vim.api.nvim_get_current_buf()
			-- 		if vim.api.nvim_buf_get_var(bufnr, "pynvim") then
			-- 			vim.wo.wrap = true
			-- 		else
			-- 			vim.wo.wrap = false
			-- 		end
			-- 	end,
			-- })
		end,
	},
}
