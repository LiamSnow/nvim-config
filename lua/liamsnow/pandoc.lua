local job = require("plenary.job")

local asset_path = vim.fn.stdpath('config') .. '/pandoc'

local extensions = table.concat({
  -- 'hard_line_breaks',      -- respect new lines
  'mark',                  -- highlighting with ==
  'lists_without_preceding_blankline',
  'rebase_relative_paths', -- image links
  'emoji',                 -- emojis with :smile:
  'short_subsuperscripts', -- x^2 or O~2
  'wikilinks_title_after_pipe',
}, '+')

local args = {
  '-f', 'markdown+' .. extensions,
  '-t', 'pdf',
  '-s',
  -- '--preserve-tabs',
  -- '--wrap=preserve',
  -- '-o', output_pdf_file,
  '--lua-filter', asset_path .. '/pdf.lua',
  '--template', asset_path .. '/pdf.tex',
  '-V', 'source-dir="' .. asset_path .. '"'
}

local last_output_file = nil

local function pandoc_run()
  local current_file = vim.fn.expand('%:p')
  local output_file = current_file:gsub('%.%w+$', '.pdf')

  job:new({
    command = 'pandoc',
    args = vim.list_extend({
      current_file,
      '-o', output_file
    }, args),
    cwd = vim.loop.cwd(),
    on_exit = function(response, exit_code)
      if (exit_code ~= 0) then
        local error_message = table.concat(response:stderr_result(), "\n")
        print("Pandoc run failed!", exit_code, error_message)
      else
        print("Pandoc output to", output_file)
      end
    end,
  }):start()

  last_output_file = output_file
end

local function pandoc_view()
  job:new({
    command = 'firefox',
    args = { last_output_file },
    cwd = vim.loop.cwd(),
    on_exit = function(response, exit_code)
      if (exit_code ~= 0) then
        print("Firefox failed to start!",
          exit_code, table.concat(response:result(), "\n"))
      end
    end,
  }):start()
end

vim.api.nvim_create_user_command("PandocRun", pandoc_run, {})
vim.api.nvim_create_user_command("PandocView", pandoc_view, {})

vim.keymap.set("n", "<C-p>", pandoc_run)
vim.keymap.set("n", "<leader><C-p>", pandoc_view)

