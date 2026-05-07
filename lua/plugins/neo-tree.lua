return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    -- This handles the opening/closing from your editor
    keys = {
      { "<leader>g", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    -- Everything that was "not working" goes inside this opts table
    opts = {
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["q"] = "close_window", -- Added this so to close with 'q'
          ["g"] = "close_window", -- Added this so to close with 'g'
        },
      },
      filesystem = {
        filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
                -- add extension names you want to explicitly exclude
                -- '.git',
                -- '.DS_Store',
                -- 'thumbs.db',
            },
            never_show = {},
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
  },
}
