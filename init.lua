local u = require('util')
local map = u.vim.map
local hi = u.vim.hi

vim.o.swapfile = false

-- vim.opt.rtp:append('/usr/local/opt/fzf')
vim.opt.path:append('**')
vim.o.shell = 'zsh'

vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.o.autocomplete = false

-- vim.o.cursorcolumn = true
-- vim.o.cursorline = true
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

	{ src = 'https://github.com/Saghen/blink.cmp' },

	{ src = 'https://github.com/bjarneo/pixel.nvim' },
	-- { src = 'https://github.com/sainnhe/everforest' },

	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/chomosuke/typst-preview.nvim' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
	{ src = 'https://github.com/folke/trouble.nvim' },

	{ src = 'https://github.com/laishulu/vim-macos-ime' },
})

require('oil').setup()

require('mini.pick').setup()

require('mini.pairs').setup()

require('mini.surround').setup()

require('mini.git').setup()

require('mini.diff').setup()

local msnip = require('mini.snippets')
msnip.setup({
	snippets = {
		msnip.gen_loader.from_lang()
	}
})

require('nvim-treesitter.configs').setup({
	highlight = {
		enabled = true
	},
	indent = { enable = true },
	auto_install = false,
	ensure_installed = { 'nu', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'c_sharp', 'haskell', 'typst', }
})

require('mason').setup()

require('trouble').setup()

vim.lsp.enable({
	'lua_ls',
	'tinymist',
	'nushell',
	'svlangserver',
	'java-language-server',
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

vim.g.macosime_cjk_ime = 'com.apple.inputmethod.SCIM.ITABC'
vim.g.macosime_normal_ime = 'com.apple.keylayout.USExtended'

-- colorscheme
vim.cmd("colorscheme pixel")
-- vim.cmd([[
-- 	let g:everforest_background = 'hard'
-- 	let g:everforest_better_performance = 1
-- 	let g:everforest_dim_inactive_windows = 1
-- 	colorscheme everforest
-- ]])
-- highlights
hi('statusline', { ctermbg = 'NONE', guibg = 'NONE' })
hi('statuslineNC', { ctermbg = 'NONE', guibg = 'NONE' })

hi('SpellBad', { gui = 'undercurl', cterm = 'undercurl' })

hi('Normal', { ctermbg = 'NONE', guibg = 'NONE' })
hi('NormalNC', { ctermbg = 'NONE', guibg = 'NONE' })

vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
	pattern = '*',
})

map({ 'n', 'v', 'x' }, ';', ':')

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

map('n', 'gd', vim.lsp.buf.definition)

map('n', '<leader>xx', '<CMD>Trouble diagnostics toggle<CR>')
map('n', '<leader>xr', '<CMD>Trouble lsp_references toggle<CR>')
map('n', '<leader>xs', '<CMD>Trouble symbols toggle<CR>')
map('n', '<leader>xq', '<CMD>Trouble qflist toggle<CR>')

-- Quick terminal normal mode
map('t', '<ESC>', '<C-\\><C-n>', { desc = "Exit Ternimal Insert mode", noremap = true })
-- <C-w> in terminal mode
-- <C-\><C-o> for a command in terminal mode
map('t', '<C-w>', '<C-\\><C-o><C-w>', { desc = "Exit Ternimal Insert mode", noremap = true })
-- Enter terminal insert mode on enter window
vim.cmd([[
  autocmd BufWinEnter,BufEnter term://* startinsert
  autocmd BufWinLeave,BufLeave term://* stopinsert
]])
