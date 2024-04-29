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

local default_temp = 0.2

return {
  {
    "huynle/ogpt.nvim",
    event = "VeryLazy",
    opts = {
      default_provider = "anthropic",
      providers = {
        anthropic = {
          enabled = true,
          api_key = anthropic_key,
          model = "claude-3-opus-20240229",
          api_params = {
            temperature = default_temp,
            top_p = 0.99,
            max_tokens = 1024,
          },
          api_chat_params = {
            temperature = default_temp,
            top_p = 0.99,
            max_tokens = 1024,
          },
        },
        openai = {
          enabled = true,
          model = "gpt-4-turbo",
          api_host = "https://api.openai.com",
          api_key = openai_key,
          api_params = {
            temperature = default_temp,
            top_p = 0.99,
          },
          api_chat_params = {
            temperature = default_temp,
            frequency_penalty = 0.8,
            presence_penalty = 0.5,
            top_p = 0.99,
          },
        },
      },
      output_window = {
        border = {
          text = {
            top = "",
          }
        }
      },
      input_window = {
        border = {
          text = {
            top = "",
          }
        }
      },
      chat = {
        welcome_message = "Project Flux%"
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    keys = {
      { "<C-=>", "<cmd>OGPT<cr>", desc = "Open OGPT" },
    },
    init = function()
    end
  }
}
