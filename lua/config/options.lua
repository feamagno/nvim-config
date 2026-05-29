-- Basic settings
vim.opt.number = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers

vim.opt.tabstop = 4 -- Number of spaces a tab represents
vim.opt.softtabstop = 4 -- Number of spaces a tab represents
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation
vim.opt.expandtab = true -- Convert tabs to spaces

vim.opt.smartindent = true -- Automatically indent new lines

vim.opt.wrap = false -- Disable line wrapping

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

vim.opt.guicursor = "a:block"

vim.opt.wrap = true          -- Enable line wrapping
vim.opt.linebreak = true     -- Wrap lines at convenient points (like spaces) instead of mid-word
