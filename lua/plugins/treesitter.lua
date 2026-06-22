return {
   "nvim-treesitter/nvim-treesitter",
   branch = "main",
   lazy = false,
   build = ":TSUpdate",
   config = function()
       require("nvim-treesitter").setup({
           ensure_installed = {
               "javascript", "java", "c", "lua", "vim", "vimdoc", "query",
               "markdown", "markdown_inline", "python",
           },
           sync_install = false,
           auto_install = true,
       })

       vim.api.nvim_create_autocmd("FileType", {
           callback = function(args)
               if args.match == "tex" then return end
               pcall(vim.treesitter.start)
               vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
           end,
       })
   end,
}
