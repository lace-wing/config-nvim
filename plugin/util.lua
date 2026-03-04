local u = require('util')
local map = u.vim.map

vim.pack.add({
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim', },
  { src = 'https://github.com/folke/which-key.nvim', },
  { src = 'https://github.com/jpalardy/vim-slime' },

  { src = 'https://github.com/laishulu/vim-macos-ime' },
  { src = 'https://github.com/chomosuke/typst-preview.nvim' },
})

require('oil').setup()

require('mini.pick').setup()

require('mini.pairs').setup()

require('mini.surround').setup()

require('mini.git').setup()

require('mini.diff').setup()

vim.g.slime_target = 'neovim'

vim.g.macosime_cjk_ime = 'com.apple.inputmethod.SCIM.ITABC'
vim.g.macosime_normal_ime = 'com.apple.keylayout.USExtended'

map('n', '<LEADER>f', ':Pick files<CR>')
map('n', '<LEADER>b', ':Pick buffers<CR>')
map('n', '<LEADER>h', ':Pick help<CR>')
map('n', '<LEADER>e', ':Oil<CR>')

