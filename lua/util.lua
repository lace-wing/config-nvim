local M = {
	vim = require('util.vim'),
	path = require('util.path'),
}

function M.use (module, force)
	force = force or false
	for k, v in pairs(module) do
		if not force and _G[k] then
			warn('use: skipping duplicate symbol `' .. k .. '`\n')
		else
			_G[k] = v
		end
	end
end

return M
