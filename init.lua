if vim.fn.has('wsl') == 1 and vim.fn.executable('clip.exe') == 1 and vim.fn.executable('powershell.exe') == 1 then
  local copy_command = {
    'powershell.exe',
    '-NoLogo',
    '-NoProfile',
    '-Command',
    table.concat({
      '[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)',
      '$text = [Console]::In.ReadToEnd()',
      'Set-Clipboard -Value $text',
    }, '; '),
  }

  local paste_command = {
    'powershell.exe',
    '-NoLogo',
    '-NoProfile',
    '-Command',
    table.concat({
      '[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)',
      '$clip = Get-Clipboard -Raw',
      'if ($null -ne $clip) { [Console]::Out.Write($clip.ToString().Replace("`r", "")) }',
    }, '; '),
  }

  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = copy_command,
      ['*'] = copy_command,
    },
    paste = {
      ['+'] = paste_command,
      ['*'] = paste_command,
    },
    cache_enabled = 0,
  }
end

-- require calling essential config
require('config.options')
require('config.keymaps')
require('config.lazy')
require('config.macros')
-- require('config.jdtls')

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', {clear = true}),
    callback = function ()
        vim.highlight.on_yank()
    end,
})
