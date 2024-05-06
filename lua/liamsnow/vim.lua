-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- undo
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- mouse
vim.api.nvim_set_keymap('', '<LeftMouse>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<RightMouse>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<2-LeftMouse>', '<Nop>', { noremap = true, silent = true })
-- vim.opt.mouse = ""
-- vim.opt.mousescroll = "ver:0,hor:0"
-- vim.keymap.set("", "<up>", "<nop>", { noremap = true })
-- vim.keymap.set("", "<down>", "<nop>", { noremap = true })
-- vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
-- vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

-- other
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.conceallevel = 0

-- shell
vim.opt.shell = "zsh"
-- vim.opt.shellcmdflag = "-ic"

-- leader
vim.g.mapleader = " "

-- better split window navigation
vim.keymap.set("n", "<A-v>", ":vsplit<CR>")
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")
vim.keymap.set("n", "<A-S-h>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<A-S-j>", ":resize +2<CR>")
vim.keymap.set("n", "<A-S-k>", ":resize -2<CR>")
vim.keymap.set("n", "<A-S-l>", ":vertical resize +2<CR>")

-- move selection up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move long lines
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in middle when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor in middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over without loosing clipboard
vim.keymap.set("x", "<A-p>", [["_dP]])

-- delete without copy
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- system clipboard (asbjornhaland)
vim.keymap.set({ "n", "v" }, "<A-y>", [["+y]])
vim.keymap.set("n", "<A-Y>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<A-p>", [["+p]])
vim.keymap.set({ "n", "v" }, "<A-P>", [["+P]])

-- format selection
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- quick fix list
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- chmod bash
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
