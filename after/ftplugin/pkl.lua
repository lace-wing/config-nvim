vim.lsp.start({
  cmd = { "java", "-jar", "/Users/steve/src/pkl-lsp/bin/pkl-lsp-0.1.2.jar" },
  root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
})
