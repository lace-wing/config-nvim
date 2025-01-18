vim.opt_local.spell = true
vim.opt_local.spelllang = "en,cjk"

local git_root_cmd = "git rev-parse --show-toplevel"
local root = vim.fn.expand("%:p:h")
if os.execute(git_root_cmd) == 0 then
  root = vim.fn.system(git_root_cmd)
end

-- vim.api.nvim_create_autocmd(
--   "BufWritePost", {
--     pattern = "main.typ",
--     callback = function()
--       vim.fn.system("typst compile " .. vim.fn.expand("%:p") .. " --root " .. root)
--     end
--   }
-- )
