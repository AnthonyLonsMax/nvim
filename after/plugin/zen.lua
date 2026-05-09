local zen = require("zen-mode")

vim.keymap.set("n", "<leader>z", function()
	zen.toggle({
		window = {
			width = 0.85, -- width will be 85% of the editor width
		},
	})
end, { desc = "Toggle zen mode" })
