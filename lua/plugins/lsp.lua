local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())


        -- fidget.nvim (disable spam)
        require("fidget").setup({ enabled = false })

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "jdtls",
                "tailwindcss",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0

                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
                ["tailwindcss"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tailwindcss.setup({
                        capabilities = capabilities,
                        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
                    })
                end,
                ["jdtls"] = function()
                    local lspconfig = require("lspconfig")
                    -- This find_root function ensures we are at the project level (pom.xml/gradle)
                    local root_dir = lspconfig.util.root_pattern("pom.xml", "gradlew", ".git")(vim.fn.expand("%:p:h"))
                    -- If no root is found, don't start to avoid "single file mode" blindness
                    if not root_dir then return end
                    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
                    lspconfig.jdtls.setup({
                        cmd = { "jdtls", "-data", workspace_dir },
                        capabilities = capabilities, -- Uses the capabilities defined in your lsp.lua
                        root_dir = root_dir,
                        settings = {
                            java = {
                                format = { enabled = true },
                                configuration = {
                                    runtimes = {
                                        {
                                            name = "JavaSE-17",
                                            path = "/usr/lib/jvm/java-17-openjdk",
                                            default = true, -- This tells Neovim to use 17 for this project
                                        },
                                        {
                                            name = "JavaSE-21",
                                            path = "/usr/lib/jvm/java-21-openjdk",
                                        },
                                    },
                                },
                                eclipse = { downloadSources = true },
                                maven = { downloadSources = true },
                                implementationsCodeLens = { enabled = true },
                                referencesCodeLens = { enabled = true },
                            }
                        },
                    })
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })


        vim.diagnostic.config({
            -- update_in_insert = true,
            virtual_text = false,  -- no inline errors
            signs = true,          -- show in gutter
            underline = true,
            update_in_insert = false,  -- only after leaving insert mode
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
        
        -- Diagnostics keymaps
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Diagnostics to location list" })

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = "Go to Definition" })
        vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, { desc = "Hover Documentation" })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP Code Action (Import/Fix)" })
    end
}
