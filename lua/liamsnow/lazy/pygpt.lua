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
    -- build = function()
      -- vim.cmd([[silent UpdateRemotePlugins]])
    -- end,
    config = function()
      require("pygpt").setup({
        anthropic_key = anthropic_key,
        openai_key = openai_key
      })
    end
  },
}
