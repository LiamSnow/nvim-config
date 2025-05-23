local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- spec = "liamsnow.lazy",
    spec = {
      {import = "liamsnow.lazy"},
      {import = "liamsnow.lazy.ide"},
      {import = "liamsnow.lazy.preview"},
      {import = "liamsnow.lazy.nav"},
      {import = "liamsnow.lazy.style"},
      {import = "liamsnow.lazy.tweaks"},
    },
    change_detection = { notify = false },
    ui = {
        backdrop = 100
    }
})
