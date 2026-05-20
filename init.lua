-- require calling essential config
require('config.options')
require('config.keymaps')
require('config.lazy')
require('config.macros')
-- require('config.jdtls')


vim.g.clipboard = {
  name = "pbcopy",
  copy = {
    ["+"] = { "pbcopy" },
    ["*"] = { "pbcopy" },
  },
  paste = {
    ["+"] = {  "pbcopy" },
    ["*"] = {  "pbcopy" },
  },
  cache_enabled = 0;
}

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
    callback = function ()
        vim.highlight.on_yank()
    end,
})
