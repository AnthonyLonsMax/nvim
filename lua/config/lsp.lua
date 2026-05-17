vim.lsp.enable({
	"gopls",
	"lua_ls",
	"rust_analyzer",
	"pyrefly",
	"vue_ls",
	"vtsls",
	"cssls",
	"bashls",
	"html",
	"tailwindcss",
	"djls",
	"dockerls",
	"docker_compose_language_service",
	"zls",
	"templ",
	"intelephense",
  'csharp_ls',
  'clangd',
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	sings = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
			},
		},
	},
})
