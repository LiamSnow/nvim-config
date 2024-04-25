-- Define the path to your cheatsheet file
local cheatsheet_file = vim.fn.stdpath('config') .. "/Cheatsheet.md"

-- Create a custom command ':cheat'
vim.api.nvim_create_user_command('Cheat', function()
  -- Get the current window dimensions
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  -- Calculate the dimensions of the floating window
  local win_width = math.floor(width * 0.8)
  local win_height = math.floor(height * 0.8)
  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  -- Create a new floating window
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  })

  -- Set the window options
  vim.api.nvim_win_set_option(win, "number", true)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "cursorline", true)
  vim.api.nvim_win_set_option(win, "conceallevel", 2)

  -- Read the contents of the cheatsheet file into the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(cheatsheet_file))

  -- Set the buffer to be read-only
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Set the filetype for syntax highlighting (optional)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
end, {})
