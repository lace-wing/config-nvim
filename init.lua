local function get_root()
	local root = vim.fs.root(0, '.git')
	if root then
		return root
	end
	return vim.fn.getcwd(0)
end

local map = vim.keymap.set

vim.o.swapfile = false

-- vim.opt.rtp:append('/usr/local/opt/fzf')
-- vim.opt.path:append('**')
vim.opt.shell = 'bash'

vim.o.undofile = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.signcolumn = 'yes'
vim.o.winborder = 'single'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect")

vim.pack.add({
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/nvim-mini/mini.nvim', },
	{ src = 'https://github.com/folke/which-key.nvim', },

	{ src = 'https://github.com/slugbyte/lackluster.nvim' },

	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/chomosuke/typst-preview.nvim' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },

	{ src = 'https://github.com/Saghen/blink.cmp' }
})

require('oil').setup()

require('mini.pick').setup()
require('mini.pairs').setup()
require('mini.surround').setup()

require('nvim-treesitter.configs').setup({
	highlight = {
		enabled = true
	},
	indent = { enable = true },
	auto_install = false,
	ensure_installed = {
		'c',
		'cpp',
		'go',
		'lua',
		'python',
		'rust',
		'typescript',
		'c_sharp',
		'haskell',
	}
})

require('typst-preview').setup({
	get_root = get_root

})
map('n', '<leader>tp', ':TypstPreviewToggle<CR>', { desc = 'Typst [P]review' })

vim.lsp.enable({
	'lua_ls',
	'tinymist',
})

require('mason').setup()

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true)
			},
			telemetry = { enable = false },
		}
	}
})

vim.lsp.config('tinymist', {
	filetypes = { 'typst' },
	exportPdf = 'never',
	formatterMode = "typstyle",
	get_root = get_root,

})

require('blink-cmp').setup({
	completion = {
		list = {
			selection = {
				preselect = false
			}
		}
	},
	signature = {
		enabled = true
	},
	documentation = {
		auto_show = true,
		auto_show_delay_ms = 500,
	},
	fuzzy = { implementation = 'lua' },
})

vim.cmd("colorscheme lackluster-hack")
vim.cmd([[
	hi statusline guibg=NONE
	hi statuslineNC guibg=NONE

  hi clear SpellBad
  hi SpellBad gui=undercurl cterm=undercurl

  hi Normal guibg=NONE
  hi NormalNC guibg=NONE

	hi CursorLine guibg=black
	hi CursorColumn guibg=black
]])

map({ 'n', 'v', 'x', }, 'j', 'gj')
map({ 'n', 'v', 'x', }, 'k', 'gk')

map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')

map({ 'n', 'v', 'x' }, '<leader>y', '"+y')
map({ 'n', 'v', 'x' }, '<leader>d', '"+d')
map({ 'n', 'v', 'x' }, '<leader>p', '"+p')

map('n', '<leader>f', ':Pick files<CR>')
map('n', '<leader>h', ':Pick help<CR>')
map('n', '<leader>e', ':Oil<CR>')

map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>w', ':write<CR>')
