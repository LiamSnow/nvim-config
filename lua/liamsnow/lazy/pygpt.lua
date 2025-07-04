local function read_map(file_path)
    local file = io.open(file_path, "r")
    local map = {}

    if file then
        for line in file:lines() do
            local key, value = line:match("([^=]+)=([^=]+)")
            if key and value then
                map[key] = value
            end
        end
        file:close()
    else
        error("Could not open file: " .. file_path)
    end

    return map
end

local think_prompt = [[
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
5. Use examples when relevant
]]

local basic_prompt = [[
You are a professional AI assistant designed to approach problems methodically.
1. Offer suggestions tactfully when appropriate to improve outcomes
2. Prioritize providing honest, critical feedback over being agreeable or nice to the user
3. Split up your answer into logical sections
4. If you are not confident in any part of your response, prefacing with "I THINK"
5. Use examples when relevant
]]

local search_prompt = [[
You are a helpful search assistant.

Your task is to deliver an accurate response to a user's query, drawing from the given search results. Your answer must be precise, of high-quality, and written by an expert using an unbiased and journalistic tone.
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
            local api_keys = read_map(os.getenv("HOME") .. "/.models")

			require("pygpt").setup({
                api_keys = {
                    anthropic = api_keys['ANTHROPIC'],
                    openai = api_keys['OPENAI'],
                    perplexity = api_keys['PERPLEXITY'],
                    deepseek = api_keys['DEEPSEEK'],
                },
                chat_dir = "~/.cache/nvim/pygpt/",
                default_config = "claude_think_hidden",
                configs = {
                    claude_basic = {
                        provider = "anthropic",
                        model = "claude-sonnet-4-20250514",
                        thinking = false,
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = basic_prompt:gsub("\n", "\\n")
                    },
                    claude_think_prompt = {
                        provider = "anthropic",
                        model = "claude-sonnet-4-20250514",
                        thinking = false,
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = think_prompt:gsub("\n", "\\n")
                    },
                    claude_think = {
                        provider = "anthropic",
                        model = "claude-sonnet-4-20250514",
                        thinking = true,
                        max_tokens = 20000,
                        -- TODO new prompt
                        system = "You are a professional AI assistant designed to approach problems methodically. Use examples when relevant."
                    },
                    claude_think_opus = {
                        provider = "anthropic",
                        model = "claude-opus-4-20250514",
                        thinking = true,
                        max_tokens = 20000,
                        -- TODO new prompt
                        system = "You are a professional AI assistant designed to approach problems methodically. Use examples when relevant."
                    },
                    claude_think_hidden = {
                        provider = "anthropic",
                        model = "claude-sonnet-4-20250514",
                        thinking = true,
                        hide_thinking = true,
                        hide_markers = true,
                        max_tokens = 20000,
                        -- TODO new prompt
                        system = "You are a professional AI assistant designed to approach problems methodically. Use examples when relevant."
                    },
                    deepseek = {
                        provider = "deepseek",
                        model = "deepseek-chat",
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = think_prompt:gsub("\n", "\\n")
                    },
                    chat = {
                        provider = "openai",
                        model = "gpt-4o",
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = basic_prompt:gsub("\n", "\\n")
                    },
                    perplexity = {
                        provider = "perplexity",
                        model = "sonar-pro",
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = search_prompt:gsub("\n", "\\n"),
                    },
                    perplexity_deep = {
                        provider = "perplexity",
                        model = "sonar-deep-research",
                        temperature = 0.2,
                        max_tokens = 4000,
                        system = search_prompt:gsub("\n", "\\n"),
                    }
                }
			})

			vim.keymap.set({ "n", "v" }, "<C-=>", ":PyGPTToggle<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->p", ":PyGPTNew perplexity<CR>")
			vim.keymap.set({ "n", "v" }, "<C--><C-p>", ":PyGPTNew perplexity_deep<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->d", ":PyGPTNew deepseek<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->o", ":PyGPTNew chat<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->b", ":PyGPTNew claude_basic<CR>")
			vim.keymap.set({ "n", "v" }, "<C-->a", ":PyGPTNew claude_think<CR>")
			vim.keymap.set({ "n", "v" }, "<C--><C-a>", ":PyGPTNew claude_think_prompt<CR>")

			vim.keymap.set("v", "<C-j>", ":PyGPTRun<CR>")
			vim.keymap.set("n", "<C-A-j>", ":PyGPTStop<CR>")

			vim.keymap.set("n", "<C-A-=>", ":PyGPTExplorer<CR>")
		end,
	},
}
