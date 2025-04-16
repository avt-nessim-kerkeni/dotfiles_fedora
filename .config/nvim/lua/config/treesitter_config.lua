local M = {}

M.opts = {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'markdown', 'markdown_inline' },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    highlight = {
        enable = true,
        disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
        additional_vim_regex_highlighting = false,
    },
}

function M.setup()
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup(M.opts)
end

return M
