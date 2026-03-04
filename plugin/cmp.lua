local u = require('util')

vim.pack.add({
  { src = 'https://github.com/Saghen/blink.cmp' },
  { src = 'https://github.com/nvim-mini/mini.nvim', },
})

require('blink-cmp').setup({
  completion = {
    list = {
      selection = {
        preselect = false
      }
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  signature = {
    enabled = true
  },
  fuzzy = { implementation = 'lua' },
  keymap = {
    preset = 'default',
    ['<C-k>'] = {},
  },
  appearance = {
    use_nvim_cmp_as_default = true,
  }
})

vim.cmd("set completeopt+=noselect")

u.lsp.setup_completion()

local msnip = require('mini.snippets')
msnip.setup({
  snippets = {
    msnip.gen_loader.from_lang()
  }
})

