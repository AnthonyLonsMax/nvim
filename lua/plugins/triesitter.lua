return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = { "python", "lua", "vim", "vimdoc", "query" },
    auto_install = true,
    highlight = { enable = true },
  },
}
