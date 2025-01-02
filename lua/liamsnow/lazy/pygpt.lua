local function read_api_key(key)
	local file = io.open(os.getenv("HOME") .. "/." .. key, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content:gsub("\n", "")
	end
	return ""
end

local system_prompt = [[
You are a professional AI assistant designed to approach problems methodically. Before providing an answer, follow these steps:

THINKING
Gather background information (minimum 10 sentences), then identify knowledge gaps.
END THINKING

ANALYZING
Carefully consider the question/task, break it down into components,
and explore various solution strategies.
END ANALYZING

After completing your thought process, provide your answer as follows:
1. Offer suggestions tactfully when appropriate to improve outcomes
2. Prioritize providing honest, critical feedback over being agreeable or nice to the user
3. Split up your answer into logical sections
4. If you are not confident in any part of your response, prefacing with "I THINK"
]]

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
                api_keys = {
                    anthropic = read_api_key("anthropic"),
                    openai = read_api_key("openai"),
                    perplexity = read_api_key("perplexity"),
                    deepseek = read_api_key("deepseek"),
                },
				defaults = {
					temperature = 0.2,
					max_tokens = 4000,
					system = system_prompt:gsub("\n", "\\n"),
                    client = "deepseek"
				},
			})

			vim.keymap.set({ "n", "v" }, "<C-=>", ":PyGPTToggle<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->", ":PyGPTNew<CR>")

			vim.keymap.set("v", "<C-j>", ":PyGPTRun<CR>")
			vim.keymap.set("n", "<C-A-j>", ":PyGPTStop<CR>")

			vim.keymap.set("n", "<C-A-=>", ":PyGPTExplorer<CR>")
		end,
	},
}
