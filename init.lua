local u = require('util')
local map = u.vim.map
local hi = u.vim.hi

-- vim.opt.rtp:append('/usr/local/opt/fzf')
vim.opt.path:append('**')

vim.o.undofile = true
vim.o.swapfile = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.expandtab = true

vim.o.autocomplete = false

vim.o.signcolumn = 'yes'

vim.o.foldmethod = 'marker'
vim.o.foldcolumn = 'auto'
vim.o.foldlevelstart = 99

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({
  extension = {
    objdump = 'objdump'
  }
})

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

  -- { src = 'https://github.com/bjarneo/pixel.nvim' },
  -- { src = 'https://github.com/sainnhe/everforest' },
  -- { src = 'https://github.com/morhetz/gruvbox' },
  { src = 'https://github.com/p00f/alabaster.nvim' },

  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  -- { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },

  -- { src = 'https://github.com/mfussenegger/nvim-jdtls' },

  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },

  { src = 'https://github.com/chomosuke/typst-preview.nvim' },

  { src = 'https://github.com/laishulu/vim-macos-ime' },
})

require('oil').setup()

require('mini.pick').setup()

require('mini.pairs').setup()

require('mini.surround').setup()

require('mini.git').setup()

require('mini.diff').setup()

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    warn      = { pattern = '%f[%w]()WARN()%f[%W]', group = 'MiniHipatternsHack' },
    error     = { pattern = '%f[%w]()ERROR()%f[%W]', group = 'MiniHipatternsFixme' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

local msnip = require('mini.snippets')
msnip.setup({
  snippets = {
    msnip.gen_loader.from_lang()
  }
})

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  indent = { enable = true },
  fold = { enable = true, },
  auto_install = false,
  ensure_installed = { 'nu', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'c_sharp', 'haskell', 'typst', 'verilog', 'elixir' }
})

require('mason').setup()

vim.lsp.enable({
  'ltex-ls',
  'clangd',
  'lua_ls',
  'pyright',
  'tinymist',
  'nushell',
  'verible',
  -- 'veridian',
  'jdtls',
  'elixirls',
  'omnisharp',
  'nil',
})

require('trouble').setup({
  auto_preview = false,
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

local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    asm = { 'asmfmt' },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.g.macosime_cjk_ime = 'com.apple.inputmethod.SCIM.ITABC'
vim.g.macosime_normal_ime = 'com.apple.keylayout.USExtended'

-- colorscheme
vim.cmd("colorscheme alabaster")

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

hi('Folded', { ctermbg = 'NONE', guibg = 'NONE' })
hi('FoldColumn', { ctermfg = 'LightGreen', guifg = 'LightGreen', ctermbg = 'NONE', guibg = 'NONE' })

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    hi('TreesitterContext', { guisp = 'NONE' })
  end
})

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

map('n', '<LEADER>o', ':update<CR> :source<CR>')
map('n', '<LEADER>w', ':write<CR>')
map('n', '<LEADER>q', ':quit<CR>')

map({ 'n', 'v', 'x' }, '<LEADER>y', '"+y')
map({ 'n', 'v', 'x' }, '<LEADER>d', '"+d')
map({ 'n', 'v', 'x' }, '<LEADER>c', '"+c')
map({ 'n', 'v', 'x' }, '<LEADER>s', '"+s')
map({ 'n', 'v', 'x' }, '<LEADER>p', '"+p')

map({ 'n', 'v', 'x' }, '<LEADER>Y', '"+Y')
map({ 'n', 'v', 'x' }, '<LEADER>D', '"+D')
map({ 'n', 'v', 'x' }, '<LEADER>C', '"+C')
map({ 'n', 'v', 'x' }, '<LEADER>S', '"+S')
map({ 'n', 'v', 'x' }, '<LEADER>P', '"+P')

map('n', '<LEADER>f', ':Pick files<CR>')
map('n', '<LEADER>b', ':Pick buffers<CR>')
map('n', '<LEADER>h', ':Pick help<CR>')
map('n', '<LEADER>e', ':Oil<CR>')

map('n', '<LEADER>/', ':set hlsearch<CR>')

map('n', '<LEADER>l', conform.format, { desc = 'Format' })

map('n', 'gd', vim.lsp.buf.definition)

map('n', '<LEADER>xx', '<CMD>Trouble diagnostics toggle<CR>')
map('n', '<LEADER>xr', '<CMD>Trouble lsp_references toggle<CR>')
map('n', '<LEADER>xs', '<CMD>Trouble symbols toggle<CR>')
map('n', '<LEADER>xq', '<CMD>Trouble qflist toggle<CR>')

-- Quick terminal normal mode
map('t', '<ESC>', '<C-\\><C-n>', { desc = 'Exit Ternimal Insert mode', noremap = true })
-- <C-w> in terminal mode
-- <C-\><C-o> for a command in terminal mode
map('t', '<C-w>', '<C-\\><C-o><C-w>', { desc = "Exit Ternimal Insert mode", noremap = true })
-- Enter terminal insert mode on enter window
vim.cmd([[
  autocmd BufWinEnter,BufEnter term://* startinsert
  autocmd BufWinLeave,BufLeave term://* stopinsert
]])
