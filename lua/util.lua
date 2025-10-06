local M = {
	vim = require('util.vim'),
	path = require('util.path'),
	parse = require('util.parse'),
}

function M.use (module, force)
	force = force or false
	for k, v in pairs(module) do
		if not force and _G[k] then
			-- vim.notify('use: skipping duplicate symbol `' .. k .. '`\n', vim.log.levels.INFO)
		else
			_G[k] = v
		end
	end
end

return M
