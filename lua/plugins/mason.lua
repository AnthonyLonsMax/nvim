return {
	"mason-org/mason.nvim",
	opts = {
		ensure_installed = {
			"gopls",
			"lua_ls",
			"ts_ls",
			"basedpyright",
			"stylua",
			"gofmt",
			"goimports",
			"ruff_format",
			"prettier",
			"vue-language-server",
			"bash-language-server",
			"vtsls",
			"oxfmt",
			"html-lsp",
			"tailwindcss-language-server",
			"css-lsp",
			"django-language-server",
			"angular-language-server",
			"docker-language-server",
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}
