local M = {}

function M.get_root_with(source, ...)
	return vim.fs.root(source, { '.git', ... }) or vim.fn.expand("%:p:h")
end

function M.get_root()
	return M.get_root_with(0)
end

return M
