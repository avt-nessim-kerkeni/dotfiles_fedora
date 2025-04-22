return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local colors = require("catppuccin.palettes").get_palette("mocha")

    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk)
        map("n", "<leader>hr", gs.reset_hunk)
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("n", "<leader>hS", gs.stage_buffer)
        map("n", "<leader>hu", gs.undo_stage_hunk)
        map("n", "<leader>hR", gs.reset_buffer)
        map("n", "<leader>hp", gs.preview_hunk)
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end)
        map("n", "<leader>tb", gs.toggle_current_line_blame)
        map("n", "<leader>hd", gs.diffthis)
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end)
        map("n", "<leader>td", gs.toggle_deleted)
      end,
    })

    -- Set up colors to match Catppuccin Mocha theme using vim.api.nvim_set_hl
    vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green })
    vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red })

    -- Highlight groups for line number column when numhl is enabled
    vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = colors.green })
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = colors.red })

    -- Optional highlight groups for lines when linehl is enabled
    vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = colors.green, blend = 10 })
    vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = colors.yellow, blend = 10 })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = colors.red, blend = 10 })

    -- Additional highlight groups for the preview window
    vim.api.nvim_set_hl(0, "GitSignsAddInline", { fg = colors.base, bg = colors.green })
    vim.api.nvim_set_hl(0, "GitSignsChangeInline", { fg = colors.base, bg = colors.yellow })
    vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { fg = colors.base, bg = colors.red })

    -- Current line blame highlighting
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = colors.overlay0 })
  end,
  dependencies = {
    "catppuccin/nvim", -- Make sure Catppuccin is loaded before GitSigns
  },
}
