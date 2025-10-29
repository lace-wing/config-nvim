local M = {}

M.inline_equation = {
	prefix = 'm',
	body = [[\$$1\$]]
}

M.block_equation = {
	prefix = 'mm',
	body = [[
\$
	$0
\$]]
}

M.equation_super = {
	prefix = 'sp',
	body = '$1^($2)'
}

M.equation_sub = {
	prefix = 'sb',
	body = '$1_($2)'
}

M.fraction = {
	prefix = 'fr',
	body = '($1) / ($2)'
}

M.equation_align = {
	prefix = 'al',
	body = '$1 & $0 \\'
}

M.ampersand = {
	prefix = 'am',
	body = '&'
}

M.inline_code = {
	prefix = 'c',
	body = '```$1 $2```'
}

M.block_code = {
	prefix = 'cc',
	body = [[
```$1
$0
```]]
}

return M
