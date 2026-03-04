vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  fold = { enable = true, },
  auto_install = false,
  ensure_installed = { 'nu', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'c_sharp', 'fsharp', 'haskell', 'typst', 'verilog', 'elixir' }
})

