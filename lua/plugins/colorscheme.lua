function ColorMyPencils(color)
    color = color or "gruvbox"
    vim.o.background = "light"
    vim.cmd.colorscheme(color)
end

return {
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "frappe",
                transparent_background = false,
                integrations = {
                    gitsigns = true,
                    harpoon = true,
                    mason = true,
                    native_lsp = { enabled = true },
                    neotree = true,
                    telescope = { enabled = true },
                    treesitter = true,
                },
            })
            ColorMyPencils("catppuccin")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                contrast = "soft",
            })
            ColorMyPencils("gruvbox")
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({ "*" }, {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = false, -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
            }) 
        end,
    }
}

