local M = {}

M.inline_equation = {
	prefix = 'm',
	body = [[\$$1\$]]
}

M.block_equation = {
	prefix = 'mm',
	body = [[
\$
	$1
\$
]]
}

M.power = {
	prefix = 'pow',
	body = '($1)^($0)'
}

M.fraction = {
	prefix = 'fr',
	body = '($1) / ($0)'
}

M.equation_align = {
	prefix = 'al',
	body = '$1 & $2 $0 \\'
}

M.ampersand = {
	prefix = 'am',
	body = '&'
}

return M
