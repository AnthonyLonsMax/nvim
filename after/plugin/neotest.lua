require("neotest").setup({
	adapters = {
		require("neotest-python"),
		require("neotest-vitest"),
	},
})

vim.keymap.set("n", "<leader>tu", require("neotest").summary.toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>to", require("neotest").output_panel.toggle, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tn", require("neotest").run.run, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tw", function()
	require("neotest").watch.toggle(vim.fn.expand("%"))
end, { noremap = true, silent = true })
