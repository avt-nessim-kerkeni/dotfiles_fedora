local function inside_comment_block()
  if vim.api.nvim_get_mode().mode ~= 'i' then
    return false
  end
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  local query = vim.treesitter.query.get(vim.bo.filetype, 'highlights')
  if not parser or not node_under_cursor or not query then
    return false
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    if query.captures[id]:find 'comment' then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'moyiz/blink-emoji.nvim',
      'Kaiser-Yang/blink-cmp-dictionary',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',
        ['<C-u>'] = { 'scroll_documentation_up' },
        ['<C-d>'] = { 'scroll_documentation_down' },
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = {
          window = {
            border = 'rounded',
          },
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
          },
        },
      },

      cmdline = {
        completion = {
          menu = {
            auto_show = true,
          },
        },
        keymap = { preset = 'inherit' },
      },

      sources = {
        default = function()
          -- put those which will be shown always
          local result = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer', 'emoji' }
          if
            -- turn on dictionary in markdown or text file
            vim.tbl_contains({ 'markdown', 'text' }, vim.bo.filetype)
            -- or turn on dictionary if cursor is in the comment block
            or inside_comment_block()
          then
            table.insert(result, 'dictionary')
          end

          if vim.tbl_contains({ 'dbui', 'sql' }, vim.bo.filetype) then
            table.insert(result, 'dadbod')
          end
          return result
        end,
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          buffer = { min_keyword_length = 3 },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 93, -- the higher the number, the higher the priority
            min_keyword_length = 2,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          dictionary = {
            module = 'blink-cmp-dictionary',
            name = 'Dict',
            score_offset = 20, -- the higher the number, the higher the priority
            enabled = true,
            max_items = 30,
            min_keyword_length = 3,
            opts = {
              dictionary_directories = { vim.fn.expand '~/.config/nvim/dictionary' },
            },
          },
          dadbod = {
            name = 'Dadbod',
            module = 'vim_dadbod_completion.blink',
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = {
        enabled = true,
        window = {
          border = 'rounded',
          treesitter_highlighting = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
