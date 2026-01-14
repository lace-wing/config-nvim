" Simple Objdump Syntax
if exists("b:current_syntax")
  finish
endif

" Highlight addresses at start of line
syntax match objdumpAddress "^\s*\x\+:"
" Highlight function names in brackets
syntax match objdumpFunction "<[a-zA-Z0-9_]\+>:"
" Highlight hex opcodes (the middle column)
syntax match objdumpBinary "\s\x\x\s"

" Assign colors
highlight link objdumpAddress Type
highlight link objdumpFunction Function
highlight link objdumpBinary Comment

let b:current_syntax = "objdump"
