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
          ["q"] = "close_window", -- Added this so you can close it with 'q'
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
  },
}
