local lspnmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end;


return {
  --  This function gets run when an LSP connects to a particular buffer.
  -- lsp_signature keys
  on_attach_sig_help = function(_, bufnr)
    require('lsp_signature').on_attach({
      select_signature_key = '<C-l>',
      toggle_key = '<C-k>',
      move_cursor_key = '<C-j>',
    }, bufnr)

    -- See `:help K` for why this keymap
    lspnmap('K', vim.lsp.buf.hover, 'Hover Documentation')

    lspnmap('<C-k>', require('lsp_signature').toggle_float_win, 'Signature Documentation')
  end,

  on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    lspnmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    lspnmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    lspnmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    lspnmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    lspnmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    lspnmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    lspnmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    lspnmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

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
  end

}
