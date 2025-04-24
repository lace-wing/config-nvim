vim.lsp.start({
  name = 'tclint',
  cmd = { 'tclsp' },
  root_dir = vim.fs.root(0, { 'tclint.toml', '.tclint', 'pyproject.toml' }),
  on_attach = function (_, bufnr)
    lsp = require('lsp')
    lsp.on_attach(_, bufnr)
    -- lsp.on_attach_sig_help(_, 0) -- tclsp is yet to support textDocument/signatureHelp or hover
  end
})
