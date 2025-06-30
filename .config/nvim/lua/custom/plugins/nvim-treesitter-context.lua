return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      enable = true, -- Enable this plugin (Can be toggled later)
      max_lines = 3, -- No limit on context lines
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded
      mode = 'cursor', -- Show context at cursor position
      separator = nil, -- You can set a line separator like '─'
      zindex = 20, -- Display priority
      on_attach = nil, -- Function to run on attach
      separator = '⎯',
    }

    -- Toggle keymap: <leader>ut
    vim.keymap.set('n', '<leader>ut', function()
      local ctx = require 'treesitter-context'
      ctx.toggle()
      local status = ctx.enabled and 'enabled' or 'disabled'
      print('Treesitter Context ' .. status)
    end, { desc = 'Toggle Treesitter Context' })

    vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#16161e' })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
