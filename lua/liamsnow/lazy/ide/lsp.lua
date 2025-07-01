return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			vim.diagnostic.config({
				virtual_text = { current_line = true },
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

            vim.o.winborder = "rounded"

			require("lspconfig.ui.windows").default_options.border = "rounded"

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			require("fidget").setup()
			require("mason").setup()
			require("mason-lspconfig").setup({
				-- https://github.com/williamboman/mason-lspconfig.nvim
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"pyright",
					"cssls",
					"html",
					"yamlls",
					"marksman", -- md
					-- "hyprls"
					"tinymist",
					"ts_ls",
				},
				handlers = {
					function(server_name) -- default handler (optional)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,

					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
										path = vim.split(package.path, ";"),
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										library = {
											vim.fn.expand("$VIMRUNTIME/lua"),
											vim.fn.stdpath("config") .. "/lua",
										},
									},
								},
							},
						})
					end,

					["pyright"] = function()
						require("lspconfig").pyright.setup({
							capabilities = capabilities,
							settings = {
								pyright = {
									autoImportCompletion = true,
								},
								python = {
									analysis = {
										autoSearchPaths = true,
										diagnosticMode = "openFilesOnly",
										useLibraryCodeForTypes = true,
										typeCheckingMode = "off",
									},
								},
							},
						})
					end,

					["rust_analyzer"] = function()
						require("lspconfig").rust_analyzer.setup({
							capabilities = capabilities,
							on_attach = on_attach,
							settings = {
								["rust-analyzer"] = {
									cargo = {
										-- For Leptos & Dioxus
										allFeatures = true,
										-- loadOutDirsFromCheck = true,
										-- runBuildScripts = true,
									},
									checkOnSave = {
										allFeatures = true,
									},
								},
							},
						})
					end,

					["glint"] = function()
						require("lspconfig").glint.setup({
							capabilities = capabilities,
							filetypes = { "handlebars", "glimmer", "hbs" },
						})
					end,

					["tinymist"] = function()
						require("lspconfig").tinymist.setup({
							capabilities = capabilities,
							offset_encoding = "utf-8",
						})
					end,
				},
			})
		end,
	},
}
