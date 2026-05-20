
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

vim.fn.setreg("l", "yoSystem.out.println(\"\"" .. esc .."PA" .. esc .."i: " .. esc .."A+" .. esc .."pa);" .. esc)


