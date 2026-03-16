local u = require('util')
local map = u.vim.map

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/stevearc/conform.nvim' },

  { src = 'https://github.com/GustavEikaas/easy-dotnet.nvim' },
})

vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.enable({
  'clangd',
  'lua_ls',
  'pyright',
  'tinymist',
  'nushell',
  'easy-dotnet',
  'fsautocomplete',
  'nixd',
  -- 'harper_ls',
})

local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    asm = { 'nasmfmt' },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

map('n', '<LEADER>l', conform.format, { desc = 'Format' })

