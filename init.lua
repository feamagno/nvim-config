-- require calling essential config
require('config.options')
require('config.keymaps')
-- require('config.jdtls')

require('config.lazy')

vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = { "xclip", "-selection", "clipboard" },
    ["*"] = { "xclip", "-selection", "primary" },
  },
  paste = {
    ["+"] = { "xclip", "-selection", "clipboard", "-o" },
    ["*"] = { "xclip", "-selection", "primary", "-o" },
  },
}

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
    callback = function ()
        vim.highlight.on_yank()
    end,
})
