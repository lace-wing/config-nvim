-- Set <space> as the leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- copy to system clipborad
vim.opt.clipboard = { 'unnamedplus' }

-- some env settings
vim.opt.rtp:append('/usr/local/opt/fzf')
vim.opt.path:append('**')
vim.opt.shell = 'bash'

-- filetype settings
vim.filetype.add {
  pattern = {
    ['.*.xdc'] = 'xdc',
    ['.*.upf'] = 'upf',
  },
}

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local pid = vim.fn.getpid()
local omnisharp_bin = "~/.local/share/omnisharp/run"
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local function charcount()
  local wc = vim.fn.wordcount()
  return (wc['visual_chars'] and wc['visual_chars'] or wc['chars']) .. ' chars'
end
local function wordcount()
  local wc = vim.fn.wordcount()
  return (wc['visual_words'] and wc['visual_words'] or wc['words']) .. ' words'
end
local function linecount()
  local ln = vim.fn.line
  return (vim.fn.wordcount().visual_chars and (ln(".") - ln("v") + 1) or ln('$')) .. ' lines'
end

require('lazy').setup({

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    "williamboman/mason.nvim",
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      'folke/neodev.nvim',
      'Hoffs/omnisharp-extended-lsp.nvim'
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {}
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    'neanias/everforest-nvim',
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('everforest').setup({
        background = "hard",
        ui_contrast = "high",
      })
      vim.cmd.colorscheme 'everforest'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'everforest',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        -- lualine_y = { charcount, wordcount, linecount },
        lualine_y = {},
        lualine_z = { 'progress', 'location' }
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    lazy = false,
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install_sync"]()
    end,
    config = function()
      vim.keymap.set('n', '<leader>pp', ':MarkdownPreviewToggle<CR>', { desc = 'Markdown [P]review' })
    end
  },

  {
    'lervag/vimtex',
    init = function()
      vim.g.vimtex_view_method = "skim"
    end
  },

  {
    'laishulu/vim-macos-ime',
    lazy = false,
    config = function()
      vim.g.macosime_cjk_ime = 'com.apple.inputmethod.SCIM.ITABC'
      vim.g.macosime_normal_ime = 'com.apple.keylayout.USExtended'
    end,
  },
  -- {
  --   'jiangmiao/auto-pairs',
  -- },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon'
    },
    cmd = {
      'RainbowDelim',
      'RainbowDelimSimple',
      'RainbowDelimQuoted',
      'RainbowMultiDelim',
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
  },
  {
    'mfussenegger/nvim-dap',
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require('dap-python').setup('/opt/homebrew/bin/python3')
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    }
    -- config = function ()
    --   require('dapui').setup()
    -- end
  },
  {
    'tigion/nvim-asciidoc-preview',
    ft = { 'asciidoc' },
    config = function()
      vim.keymap.set('n', '<leader>po', ':AsciiDocPreview<CR>', { desc = 'AsciiDoc [P]review [O]pen' })
      vim.keymap.set('n', '<leader>ps', ':AsciiDocPreviewStop<CR>', { desc = 'AsciiDoc [P]review [S]top]' })
    end
  },
  {
    'andweeb/presence.nvim',
    opts = {
      neovim_image_text = 'btw I use neovim',
      main_image = 'file',
      buttons = {
        {
          label = 'Everglow',
          url = 'https://github.com/Solaestas/Everglow'
        },
        {
          label = 'Starlight River Zh',
          url = 'https://github.com/lace-wing/StarlightRiverZh'
        },
      },
    },
  },
  -- {
  --   'vimwiki/vimwiki', -- having great lantency when pressing <enter>, hence unused. re-enble after its fixed
  --   config = function()
  --     vim.g.vimwiki_global_ext = 0
  --     vim.g.vimwiki_ext2syntax = {}
  --     vim.g.vimwiki_list = {
  --       {
  --         ['path'] = '~/Projects/Project-LLL/',
  --         ['syntax'] = 'markdown',
  --         ['ext'] = '.md'
  --       }
  --     }
  --   end,
  -- },
  --[[ {
    'ojroques/nvim-osc52',
    config = function()
      local function copy(lines, _)
        require('osc52').copy(table.concat(lines, '\n'))
      end

      local function paste()
        return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
      end

      vim.g.clipboard = {
        name = 'osc52',
        copy = {['+'] = copy, ['*'] = copy},
        paste = {['+'] = paste, ['*'] = paste},
      }

      -- Now the '+' register will copy to system clipboard using OSC52
      vim.keymap.set('n', '<leader>c', '"+y')
      vim.keymap.set('n', '<leader>cc', '"+yy')
    end,
  } ]]
  {
    "folke/twilight.nvim",
    vim.keymap.set("n", "<C-t>", ":Twilight<Enter>", { desc = "Toggle [T]wilight" }),
    opts = {
      dimming = {
        alpha = 0.33,        -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        term_bg = "#1e2326", -- if guibg=NONE, this will be used to calculate text color
      },
      context = 12,
    }
  },
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh 1",
    config = function()
      require('sniprun').setup({
        display = {
          "Classic",
        },
      })
      vim.keymap.set("n", "<leader>ff", "<Plug>SnipRun", { silent = true, desc = "SnipRun" })
      vim.keymap.set("n", "<leader>F", ":%SnipRun<CR>", { silent = true, desc = "SnipRun All" })
      vim.keymap.set("n", "<leader>f", "<Plug>SnipRunOperator", { silent = true, desc = "SnipRunOperator" })
      vim.keymap.set("v", "f", "<Plug>SnipRun", { silent = true, desc = "SnipRun" })
    end,
  },
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "kristijanhusak/vim-dadbod-ui"
    }
  },
  {
    'richardbizik/nvim-toc',
    config = function()
      require 'nvim-toc'.setup()
    end
  },
  {
    "windwp/nvim-ts-autotag"
  },
  {
    "jackmort/chatgpt.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    },
    config = function()
      require("chatgpt").setup({
        actions_paths = {
          vim.fn.stdpath('config') .. '/data/chatgpt/actions.json',
        },
        openai_params = {
          model = "gpt-4o",
        }
      })
      local wk = require("which-key")
      wk.add({
        { "<leader>c",  group = "ChatGPT" },
        { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
        {
          mode = { "n", "v" },
          { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>",                 desc = "Add Tests" },
          { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>",                 desc = "Docstring" },
          { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>",           desc = "Edit with instruction" },
          { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>",                  desc = "Fix Bugs" },
          { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>",        desc = "Grammar Correction" },
          { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>",                  desc = "Keywords" },
          { "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
          { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>",             desc = "Optimize Code" },
          { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>",              desc = "Roxygen Edit" },
          { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>",                 desc = "Summarize" },
          -- { "<leader>ct", "<cmd>ChatGPTRun translate<CR>",                 desc = "Translate" },
          {
            "<leader>ct",
            function()
              local lang = vim.fn.input("Translate to: ")
              if lang ~= "" then
                lang = " --lang=" .. lang
              end
              vim.api.nvim_command("ChatGPTRun translate" .. lang)
            end,
            desc = "Translate"
          },
          { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
  },
  -- {
  --   "nat-418/tcl.nvim",
  --   dependencies = {
  --     "mfussenegger/nvim-lint",
  --   },
  -- },
  {
    "mrcjkb/haskell-tools.nvim",
    version = '^4', -- Recommended
    lazy = false,   -- This plugin is already lazy
    ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    init = function()
      vim.g.haskell_tools = {}
    end,
  },
  {
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup({
        templates = { "builtin" } --, "user.watch_typst" },
      })
    end
  },
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '0.3.*',
    build = function() require 'typst-preview'.update() end,
    opts = {
      dependencies_bin = {
        ['typst-preview'] = "tinymist",
      },
    },
    config = function()
      require 'typst-preview'.setup()
      vim.keymap.set('n', '<leader>pp', ':TypstPreviewToggle<CR>', { desc = 'Typst [P]review' })
    end
  },
  {
    -- 'github/copilot.vim'
  },
  {
    'nvim-treesitter/nvim-treesitter-context'
  },
  {
    'apple/pkl-neovim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function ()
      vim.g.pkl_neovim = {
        start_command = { "java", "-jar", "/Users/steve/src/pkl-lsp/bin/pkl-lsp-0.3.2.jar" },
      }
    end
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'kevinhwang91/promise-async',
    dependencies = {
      'kevinhwang91/promise-async'
    },
  },
  {
    'tranvansang/octave.vim'
  },
  {
    'wolandark/vim-espeak'
  }
  -- PLUGINS HERE
})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- indentation
vim.o.breakindent = true
vim.o.tabstop = 8
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- show hidden chars
vim.o.list = true
-- vim.o.listchars = "tab:>"

vim.cmd([[
  hi clear SpellBad
  hi SpellBad cterm=undercurl
  hi SpellBad gui=undercurl

  hi Normal ctermbg=NONE guibg=NONE
  hi NormalNC ctermbg=NONE guibg=NONE
]])

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Buffers, tabs, windows keymaps
vim.keymap.set('n', '<leader>tc', ':tabnew<CR>', { desc = '[T]ab [C]reate' })
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', { desc = '[T]ab [N]ext' })
vim.keymap.set('n', '<leader>tp', ':tabprevious<CR>', { desc = '[T]ab [P]revious' })
vim.keymap.set('n', '<leader>tq', ':tabclose<CR>', { desc = '[T]ab [Q]uit' })

vim.keymap.set('n', 'Z', 'ZZ', { desc = '[Z]Z' })
-- Quick terminal normal mode
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { desc = "Exit Ternimal Insert mode", noremap = true })
-- <C-w> in terminal mode
-- <C-\><C-o> for a command in terminal mode
vim.keymap.set('t', '<C-w>', '<C-\\><C-o><C-w>', { desc = "Exit Ternimal Insert mode", noremap = true })
-- Enter terminal insert mode on enter window
vim.cmd([[
  autocmd BufWinEnter,BufEnter term://* startinsert
  autocmd BufWinLeave,BufLeave term://* stopinsert
]])
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', 'gd', require('omnisharp_extended').telescope_lsp_definitions, { desc = '[G]oto [D]efinition' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c',
    'cpp',
    'go',
    'lua',
    'python',
    'rust',
    'tsx',
    'typescript',
    'vimdoc',
    'vim',
    'c_sharp',
    'elixir',
    'haskell',
    'pkl',
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader><right>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader><left>'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]

local lsp = require 'lsp'
-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp" },
  },
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },

  omnisharp = {
    -- handlers = { --TODO not working
    --   ['textDocument/definition'] = require('omnisharp_extended').handler,
    -- },
    -- cmd = {omnisharp_bin, '--languageserver' , '--hostPID', tostring(pid) },
    cmd = { 'dotnet', '/Users/steve/.local/share/nvim/mason/packages/omnisharp/libexec/omnisharp.dll' },
    -- enable_roslyn_analyzers = true,
    -- enable_import_completion = true,
    -- organize_imports_on_format = true,
    -- enable_ms_build_load_projects_on_demand = true,
  },

  sqlls = {},

  ltex = {
    cmd = { "ltex-ls" },
    filetypes = { "markdown", "text", "asciidoc", },
  },

  zls = {},

  tinymist = {
    filetypes = { 'typst' },
    exportPdf = 'onSave',
    formatterMode = "typstyle",
  },

  elixirls = {},

  arduino_language_server = {
    -- cmd = { "~/src/arduino-language-server/arduino-language-server" },
  },
}
-- add nil_ls if nix exists
-- if vim.fn.executable("nix") == 1 then
--   local nil_ls = {}
--   servers[#servers+1] = nil_ls
-- end

-- Setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.snippetSupport = true;

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_init = function(client, bufnr)
        if servers[server_name].on_init then
          servers[server_name].on_init(client, bufnr)
        end
      end,
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        lsp.on_attach_sig_help(client, bufnr)
        if servers[server_name].on_attach then
          servers[server_name].on_attach(client, bufnr)
        end
      end,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      -- single file mode
      root_dir = function(filename, bufnr)
        local p = require('lspconfig.util').root_pattern('.git')(filename)
        if (p == nil) then
          return vim.fn.getcwd()
        end
        return p
      end
    }
  end
}

-- non-mason-lspconfig setup
local nvim_lspconfig = require 'lspconfig'
-- Check if it's already defined for when reloading this file.
local sp_servers = {
  nushell = {},
}
local sp_server_names = vim.tbl_keys(sp_servers)

for i = 1, #sp_server_names do
  nvim_lspconfig[sp_server_names[i]].setup {
    settings = sp_servers[sp_server_names[i]],
    filetypes = (sp_servers[sp_server_names[i]] or {}).filetypes,
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
      lsp.on_attach_sig_help(client, bufnr)
      if sp_servers[sp_server_names[i]].on_attach then
        sp_servers[sp_server_names[i]].on_attach(client, bufnr)
      end
    end,
  }
end

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
-- add custom snippet folder to rtp
vim.opt.rtp:append(vim.fn.stdpath 'config' .. '/snippets')
require('luasnip.loaders.from_vscode').load({
  paths = {
    "~/.config/nvim/snippets/"
  }
})
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Left>'] = cmp.mapping.scroll_docs(-4),
    ['<Right>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

-- cmp for vim-dadbod
cmp.setup.filetype(
  { "sql" },
  {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" }
    }
  }
)

-- nvim-dap
-- config for debugger
local dap = require('dap')

require('dap.ext.vscode').load_launchjs() --TODO not working


dap.adapters.coreclr = {
  type = 'executable',
  command = '~/.local/share/nvim/mason/packages/netcoredbg/netcoredbg',
  -- args = {'--interpreter=vscode'}
}

vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. '/'
  if vim.g['dotnet_last_proj_path'] ~= nil then
    default_path = vim.g['dotnet_last_proj_path']
  end
  local path = vim.fn.input('Path to your *proj file: ', default_path, 'file')
  vim.g['dotnet_last_proj_path'] = path
  local cmd = 'dotnet build ' .. '\"' .. path .. '\"' .. ' > ~/dotnet-build.log' --/dev/null'
  print('\nCmd to execute: ' .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print('\nBuild: ✔️ ')
  else
    print('\nBuild: ❌ (code: ' .. f .. ')')
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
  end

  if vim.g['dotnet_last_dll_path'] == nil then
    vim.g['dotnet_last_dll_path'] = request()
  else
    if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
      vim.g['dotnet_last_dll_path'] = request()
    end
  end

  return vim.g['dotnet_last_dll_path']
end

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      vim.g.dotnet_build_project()
      return vim.g.dotnet_get_dll_path()
    end,
    cwd = "${workspaceFolder}"
  },
  {
    type = "coreclr",
    name = "tmod - launch - netcoredbg",
    request = "launch",
    program = "tModLoader.dll",
    cwd = "~/Library/Application Support/Steam/steamapps/common/tModLoader/",
    justMyCode = true,
    stopAtEntry = true,
  }, --TODO make it work
}

-- local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
local codelldb_port = '13000'
dap.adapters.codelldb = {
  type = "server",
  port = codelldb_port,
  host = "127.0.0.1",
  executable = {
    command = "codelldb",
    args = { "--port", codelldb_port },
    -- args = { "--liblldb", liblldb_path, "--port", codelldb_port },
  },
}

dap.configurations.c = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = vim.fn.getcwd(),
    stopOnEntry = false,
  }
}

dap.configurations.haskell = {

}

local dapnmap = function(keys, func, desc)
  if desc then
    desc = 'DAP: ' .. desc
  end
  vim.keymap.set('n', keys, func, { desc = desc })
end

dapnmap('<leader>Dt', dap.toggle_breakpoint, '[T]oggle Breakpoint')
dapnmap('<leader>Df', dap.step_over, 'Step Over')
dapnmap('<leader>Di', dap.step_into, 'Step [I]nto')
dapnmap('<leader>Do', dap.step_out, 'Step [O]ut')
dapnmap('<leader>Db', dap.step_back, 'Step [B]ack')
dapnmap('<leader>Dr', dap.continue, '[R]un')
dapnmap('<leader>Ds', dap.close, '[S]top')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
