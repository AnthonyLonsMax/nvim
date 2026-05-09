-- Moverse entre splits usando Ctrl + HJKL
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Para modo terminal (neovim)
vim.api.nvim_set_keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

local nvim_tmux_nav = require("nvim-tmux-navigation")
vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
nvim_tmux_nav.setup({
	disable_when_zoomed = true, -- defaults to false
})

-- Buffers stuffs
vim.keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>bh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally

vim.keymap.set(
	"n",
	"<leader>bc",
	require("telescope.builtin").git_bcommits,
	{ desc = "Lists commits for current buffer with diff preview" }
)
vim.keymap.set("n", "<leader>bx", "<cmd>q<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
vim.keymap.set(
	"n",
	"<leader>bf",
	require("telescope.builtin").current_buffer_fuzzy_find,
	{ desc = "Live fuzzy search inside of the currently open buffer" }
)
-- Resize with arrows
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
