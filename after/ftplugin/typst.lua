local u = require('util')
local map = u.vim.map

require('typst-preview').setup({
  get_root = u.path.get_root,
  dependencies_bin = {
    ['tinymist'] = 'tinymist',
  },
})

map('n', '<leader>vp', ':LspTinymistPinMain<CR>', { desc = 'Tinymist [P]in Main' })

map('n', '<leader>vv', ':TypstPreviewToggle<CR>', { desc = 'Typst Pre[v]iew' })

