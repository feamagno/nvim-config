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

        -- Configure jdtls via vim.lsp.config (Neovim 0.11+)
        local java_exec = "/opt/homebrew/opt/openjdk/bin/java"
        local java_home = vim.fn.fnamemodify(java_exec, ":h:h")
        local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
        if vim.fn.executable(jdtls_bin) == 0 then jdtls_bin = "jdtls" end

        -- Configure kotlin-language-server via vim.lsp.config (Neovim 0.11+)
        -- KLS 1.3.x can't parse Java 25 version strings; use JDK 21 instead
        local kls_java_home = "/opt/homebrew/opt/openjdk@21"
        local kls_bin = vim.fn.stdpath("data") .. "/mason/bin/kotlin-language-server"
        if vim.fn.executable(kls_bin) == 0 then kls_bin = "kotlin-language-server" end

        vim.lsp.config("kotlin_language_server", {
            cmd = { kls_bin },
            cmd_env = { JAVA_HOME = kls_java_home },
            capabilities = capabilities,
            root_markers = { "build.gradle", "build.gradle.kts", "pom.xml", "settings.gradle", "settings.gradle.kts", ".git" },
        })

        -- Disable kotlin_lsp (JetBrains pre-alpha) — we use kotlin_language_server instead
        vim.lsp.enable("kotlin_lsp", false)

        vim.lsp.config("jdtls", {
            cmd = { jdtls_bin, "--java-executable", java_exec },
            capabilities = capabilities,
            root_markers = { "pom.xml", "gradlew", "build.gradle", ".git" },
            settings = {
                java = {
                    format = { enabled = true },
                    configuration = {
                        runtimes = {
                            {
                                name = "JavaSE-1.8",
                                path = "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home",
                                default = true,
                            },
                            {
                                name = "JavaSE-25",
                                path = java_home,
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

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "jdtls",
                "kotlin_language_server",
                "tailwindcss",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["jdtls"] = function() end,
                ["kotlin_language_server"] = function() end,

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
