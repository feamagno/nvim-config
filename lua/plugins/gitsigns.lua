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
            vim.cmd('diffoff!')
          else
            vim.cmd('set wrap')
            gs.diffthis()
          end
        end, { desc = "Toggle Git Diff This" })
      end
    })
  end
}
