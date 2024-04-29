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
          temperature = 1,
          max_tokens = 1024,
          system = "You are a professional AI assistant. Format all responses in Markdown. Use Mathjax for math."
        }
			})

      vim.keymap.set({'n', 'v'}, '<C-=>', ':PyGPTToggle<CR>')
      vim.keymap.set({'n', 'v'}, '<C-->', ':PyGPTNew<CR>')

      vim.keymap.set('v', '<C-j>', ':PyGPTRun<CR>')
      vim.keymap.set('n', '<C-A-j>', ':PyGPTStop<CR>')

      vim.keymap.set('n', '<C-A-=>', ':PyGPTExplorer<CR>')
		end,
	},
}
