return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('telescope').setup({})
            local builtin = require('telescope.builtin')
            -- nothing
            --vim.api.nvim_set_keymap('n', '<Leader>pf', ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', {noremap = true, silent = true})

            --git ignore ignored
            vim.keymap.set('n', '<leader>pf', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '--no-ignore', '-g', '!.git'}})<cr>", default_opts)

            -- git ignore is respected:
            --vim.keymap.set('n', '<leader>pf', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git'}})<cr>", default_opts)

            -- doesnt show dot files + git ignore respected
            --vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<leader>ps', function() 
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
        end
    }
}
