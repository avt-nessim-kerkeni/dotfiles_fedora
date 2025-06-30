return {
  "echasnovski/mini.starter",
  version = "*",
  event = "VimEnter",
  opts = function()
    local starter = require("mini.starter")
    local items = {
      { name = "Edit init.lua", action = "e $MYVIMRC", section = "Config" },
      { name = "Config 📁", action = "e $HOME/.config/nvim", section = "Projects" },
      { name = "ApprenTIM 📁", action = "e $HOME/ApprenTIM_v_0", section = "Projects" },
      { name = "Update Plugins ⟳", action = "Lazy update", section = "System" },
      { name = "Quit Neovim", action = "qa", section = "Session" },
    }

    return {
      -- Your ASCII art header
      header = table.concat({
        [[▓██   ██▓ █    ██  █    ██    ▄████ ▓█████ ███▄    █ ]],
        [[ ▒██  ██▒ ██  ▓██▒ ██  ▓██▒▒ ██▒ ▀█▒▓█   ▀ ██ ▀█   █ ]],
        [[  ▒██ ██░▓██  ▒██░▓██  ▒██░░▒██░▄▄▄░▒███  ▓██  ▀█ ██▒]],
        [[  ░ ▐██▓░▓▓█  ░██░▓▓█  ░██░░░▓█  ██▓▒▓█  ▄▓██▒  ▐▌██▒]],
        [[  ░ ██▒▓░▒▒█████▓ ▒▒█████▓ ░▒▓███▀▒░░▒████▒██░   ▓██░]],
        [[   ██▒▒▒  ▒▓▒ ▒ ▒  ▒▓▒ ▒ ▒  ░▒   ▒  ░░ ▒░ ░ ▒░   ▒ ▒ ]],
        [[ ▓██ ░▒░  ░▒░ ░ ░  ░▒░ ░ ░   ░   ░   ░ ░  ░ ░░   ░ ▒░]],
        [[ ▒ ▒ ░░    ░░ ░ ░   ░░ ░ ░ ░ ░   ░ ░   ░     ░   ░ ░ ]],
        [[ ░ ░        ░        ░           ░     ░           ░ ]],
      }, "\n"),

      items = items,

      -- Add just the footer
      footer = "✨ Yuu-Gen Neovim",

      content_hooks = {
        starter.gen_hook.aligning("center", "center"),
      },
    }
  end,
  config = function(_, opts)
    require("mini.starter").setup(opts)

    -- Apply Catppuccin Mocha highlight tweaks for MiniStarter
    vim.api.nvim_set_hl(0, "MiniStarterHeader", { fg = "#f5e0dc" }) -- Rosewater
    vim.api.nvim_set_hl(0, "MiniStarterItem", { fg = "#cdd6f4" })  -- Text
    vim.api.nvim_set_hl(0, "MiniStarterSection", { fg = "#89b4fa" }) -- Blue
    vim.api.nvim_set_hl(0, "MiniStarterQuery", { fg = "#f38ba8" }) -- Pink
    vim.api.nvim_set_hl(0, "MiniStarterFooter", { fg = "#a6e3a1" }) -- Green
  end,
}
