return {
  name = "watch_typst",
  builder = function()
    local file = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local git_dir_cmd = "git rev-parse --show-toplevel"
    if os.execute(git_dir_cmd) == 0 then
      dir = vim.fn.system(git_dir_cmd)
    end
    local cmd = { "typst", "compile", file} --, "--root", dir }

    if vim.fn.expand("%:p:t") ~= "main.typ" then
      return {}
    end
    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "typst" },
  },
}

