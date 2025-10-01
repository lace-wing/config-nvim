-- local path = require('util.path')

return {
	cmd = { 'tinymist'},
	filetypes = { 'typst' },
	settings = {
		formatterMode = 'typstyle',
		root_dir = vim.fs.root(0, { '.git' })
	}
}
