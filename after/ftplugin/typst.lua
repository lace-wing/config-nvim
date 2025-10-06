local u = require('util')
u.use(u.vim)

require('typst-preview').setup({
	get_root = u.path.get_root,
})

map('n', '<leader>vv', ':TypstPreviewToggle<CR>', { desc = 'Typst [P]review' })
