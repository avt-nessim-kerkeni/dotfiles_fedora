local M = {}

function M.setup()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
        }),
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        },
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                max_width = 50,
            })
        },
    })
end

return M

