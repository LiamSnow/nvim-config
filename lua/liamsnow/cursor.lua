local function set_cursor_color(color)
  vim.api.nvim_command('highlight Cursor guifg=white guibg=' .. color)
end

local function update_cursor_color()
  local mode = vim.api.nvim_get_mode().mode

  -- match lualine
  if mode == 'n' then
    set_cursor_color('#82AAFF')
  elseif mode == 'v' or mode == 'V' or mode == '' then
    set_cursor_color('#C099FF')
  elseif mode == 'i' then
    set_cursor_color('#C3E88D')
  end
end

vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = "*",
  callback = update_cursor_color
})

update_cursor_color()


