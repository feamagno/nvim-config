return
{
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<C-e>",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<C-h>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "h",
      },
      {
        "<C-t>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "t" ,
      },
      {
        "<C-n>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "n",
      },
      {
        "<C-s>", 
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "s", 
      }
    }
    return keys
    end
}

