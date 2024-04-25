return {
  {
    "toppair/peek.nvim",
    dir = "~/.config/nvim/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      local peek = require("peek")
      peek.setup()

      vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
      vim.api.nvim_create_user_command("PeekClose", peek.close, {})

      vim.keymap.set("n", "<leader>l", peek.open)
      vim.keymap.set("n", "<leader><S-l>", peek.close)
    end,
  },
}
