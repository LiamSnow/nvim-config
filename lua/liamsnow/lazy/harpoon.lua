return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({
        settings = {
          save_on_toggle = false,
          sync_on_ui_close = true,
        }
      })

      vim.keymap.set("n", "<A-a>", function() harpoon:list():add() end)
      vim.keymap.set("n", "<A-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "<A-5>", function() harpoon:list():select(5) end)
      vim.keymap.set("n", "<A-6>", function() harpoon:list():select(6) end)
      vim.keymap.set("n", "<A-7>", function() harpoon:list():select(7) end)
      vim.keymap.set("n", "<A-8>", function() harpoon:list():select(8) end)
      vim.keymap.set("n", "<A-9>", function() harpoon:list():select(9) end)

      vim.keymap.set("n", "<A-S-1>", function() harpoon:list():replace_at(1) end)
      vim.keymap.set("n", "<A-S-2>", function() harpoon:list():replace_at(2) end)
      vim.keymap.set("n", "<A-S-3>", function() harpoon:list():replace_at(3) end)
      vim.keymap.set("n", "<A-S-4>", function() harpoon:list():replace_at(4) end)
      vim.keymap.set("n", "<A-S-5>", function() harpoon:list():replace_at(5) end)
      vim.keymap.set("n", "<A-S-6>", function() harpoon:list():replace_at(6) end)
      vim.keymap.set("n", "<A-S-7>", function() harpoon:list():replace_at(7) end)
      vim.keymap.set("n", "<A-S-8>", function() harpoon:list():replace_at(8) end)
      vim.keymap.set("n", "<A-S-9>", function() harpoon:list():replace_at(9) end)
    end
  }
}
