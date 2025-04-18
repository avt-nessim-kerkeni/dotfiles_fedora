return {
  "echasnovski/mini.starter",
  event = "VimEnter",
  opts = function()
    local starter = require("mini.starter")

    return {
      -- Header with ASCII art or a custom greeting
      header = table.concat({
        [[███╗   ██╗███████╗██╗   ██╗██╗███╗   ███╗]],
        [[████╗  ██║██╔════╝██║   ██║██║████╗ ████║]],
        [[██╔██╗ ██║█████╗  ██║   ██║██║██╔████╔██║]],
        [[██║╚██╗██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[██║ ╚████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[╚═╝  ╚═══╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      }, "\n"),

      -- Items to show on the start screen
      items = {
        starter.sections.builtin_actions(),
        starter.sections.recent_files(5, true),
        starter.sections.sessions(5, true),
        {
          name = "Update Plugins",
          action = "Lazy update",
          section = "Plugins",
        },
        {
          name = "Check Health",
          action = "checkhealth",
          section = "Utils",
        },
        {
          name = "Quit Neovim",
          action = "qa",
          section = "Utils",
        },
      },

      -- Footer with a custom message
      footer = "🚀 Happy Hacking with Neovim + Mini Starter",

      -- Content hooks
      content_hooks = {
        starter.gen_hook.adding_bullet("󰄾 ", false),
        starter.gen_hook.aligning("center", "center"),
      },
    }
  end,

  config = function(_, opts)
    require("mini.starter").setup(opts)

    -- Optional: show starter screen instead of Neo-tree when opening directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local arg = vim.fn.argv()[1]
        if arg and vim.fn.isdirectory(arg) == 1 then
          vim.cmd("enew")
          vim.cmd("silent! %bwipeout")
          require("mini.starter").open()
        end
      end,
    })
  end,
}

