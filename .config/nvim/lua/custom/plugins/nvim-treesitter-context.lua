return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      enable = true, -- Enable this plugin
      max_lines = 1, -- How many lines to show in context
      line_number = true,
      multiline_threshold = 20,
      trim_scope = 'outer', -- Can be 'inner', 'outer'
      mode = 'cursor', -- 'cursor' or 'topline'
      separator = '━',
    }
  end,
}
-- vim: ts=2 sts=2 sw=2 et
