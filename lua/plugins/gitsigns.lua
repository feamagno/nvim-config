return {
  "lewis6991/gitsigns.nvim",
  lazy = false, -- Load immediately on startup just like Treesitter
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      attach_to_untracked = true,
      current_line_blame = false,

      -- This function attaches the keymaps ONLY to buffers with an active Git repo
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation between changes
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Next Git Change" })

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, desc = "Previous Git Change" })

        -- Actions
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Git Hunk" })
        map('n', '<leader>hb', gs.blame_line, { desc = "Blame Current Line" })
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset/Undo Git Hunk" })
        map('n', '<leader>gf', function()
          if vim.wo.diff then
            local cur_buf = vim.api.nvim_get_current_buf()
            vim.cmd('diffoff!')
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_get_buf(win) ~= cur_buf then
                vim.api.nvim_win_close(win, true)
              end
            end
          else
            gs.diffthis()
            vim.cmd('windo set wrap')
          end
        end, { desc = "Toggle Git Diff This" })
      end
    })
  end
}
