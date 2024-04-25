return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async', 'neovim/nvim-lspconfig' },
    lazy = true,
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local ufo = require('ufo')

      vim.keymap.set('n', 'zR', function() ufo:openAllFolds() end)
      vim.keymap.set('n', 'zM', function() ufo:closeAllFolds() end)
      vim.keymap.set('n', 'zr', function() ufo:openFoldsExceptKinds() end)
      vim.keymap.set('n', 'zm', function() ufo:closeFoldsWith() end)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
      local language_servers = require("lspconfig").util.available_servers()
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup({
          capabilities = capabilities
        })
      end

      ufo.setup()
    end
  }
}
