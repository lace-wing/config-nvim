local M = {}

function M.get_root_with(fname, bufnr, ...)
	return vim.fs.root(fname or bufnr, { '.git', ... }) or vim.fn.expand("%:p:h")
end

function M.get_root(...)
	return M.get_root_with(_, 0)
end

return M
