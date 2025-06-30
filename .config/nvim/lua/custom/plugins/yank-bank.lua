return {
  'ptdewey/yankbank-nvim',
  dependencies = 'kkharji/sqlite.lua',
  config = function()
    require('yankbank').setup {
      persist_type = 'sqlite',
    }
    vim.keymap.set({ 'n', 'v' }, '<leader>y', '<cmd>YankBank<CR>', { desc = 'Access [Y]ank Bank' })
  end,
}
