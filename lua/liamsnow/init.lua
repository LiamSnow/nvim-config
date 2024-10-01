require("liamsnow.vim")
require("liamsnow.lazyinit")
require("liamsnow.pandoc")
require("liamsnow.keybinds")

vim.g.python3_host_prog = "/usr/bin/python3"

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local LiamSnowGroup = augroup("LiamSnow", {})
local YankGroup = augroup("HighlightYank", {})

-- Highlight Yank?
autocmd("TextYankPost", {
	group = YankGroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Auto Remove Whitespace
autocmd({ "BufWritePre" }, {
	group = LiamSnowGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Word Wrap for Markdown Files
autocmd({ "FileType" }, {
	group = LiamSnowGroup,
	pattern = { "markdown", "md" },
	command = "setlocal wrap linebreak",
})

-- LSP Keymaps
autocmd("LspAttach", {
	group = LiamSnowGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>ws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>of", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>gr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>rn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)
	end,
})
