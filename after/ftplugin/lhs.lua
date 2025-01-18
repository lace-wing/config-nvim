-- ~/.config/nvim/after/ftplugin/haskell.lua
local ht = require('haskell-tools')
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr, }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
-- Evaluate all code snippets
-- vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)

local lspnmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

lspnmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
lspnmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

lspnmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
lspnmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
lspnmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
lspnmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
lspnmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
lspnmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- See `:help K` for why this keymap
lspnmap('K', vim.lsp.buf.hover, 'Hover Documentation')

-- Lesser used LSP functionality
lspnmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
lspnmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
lspnmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
lspnmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [L]ist Folders')

-- Create a command `:Format` local to the LSP buffer
vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  vim.lsp.buf.format()
end, { desc = 'Format current buffer with LSP' })
