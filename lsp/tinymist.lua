return {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  settings = {
    formatterMode = 'typstyle',
    root_dir = vim.fs.root(0, { '.git' }),
    completion = {
      postfix = false,
      symbol = "stepless",
    },
  },
}
