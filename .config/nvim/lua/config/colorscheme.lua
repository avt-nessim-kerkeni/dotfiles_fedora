local M = {}

-- Initialize settings with proper fallbacks
local settings = {
  colorscheme = {
    default_theme = "sonokai", -- Hardcoded fallback
  },
}

-- Load user settings safely
local ok, user_settings = pcall(require, "config.settings")
if ok and user_settings.colorscheme then
  settings.colorscheme = vim.tbl_deep_extend("force", settings.colorscheme, user_settings.colorscheme)
end

M.themes = {
  tokyonight = {
    setup = function()
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        terminal_colors = true,
      })
    end,
    name = "tokyonight",
  },
  catppuccin = {
    setup = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        highlight_overrides = {
          mocha = function(colors)
            return {
              -- Telescope UI customizations with transparent backgrounds
              TelescopePrompt = { bg = "NONE", fg = colors.mauve },
              TelescopePromptBorder = { bg = "NONE", fg = colors.mauve },
              TelescopePromptTitle = { bg = "NONE", fg = colors.lavender },

              TelescopeResults = { bg = "NONE", fg = colors.lavender },
              TelescopeResultsBorder = { bg = "NONE", fg = colors.mauve },
              TelescopeResultsTitle = { bg = "NONE", fg = colors.lavender },

              TelescopePreview = { bg = "NONE", fg = colors.lavender },
              TelescopePreviewBorder = { bg = "NONE", fg = colors.mauve },
              TelescopePreviewTitle = { bg = "NONE", fg = colors.mauve },

              -- Selection, matching, and caret
              TelescopeMatching = { fg = colors.teal, bold = true },
              TelescopeSelection = { bg = colors.mauve, fg = colors.base, bold = true },
              TelescopeSelectionCaret = { fg = colors.pink },

              -- Prefixes for prompt and caret
              TelescopePromptPrefix = { fg = colors.mauve },
              TelescopeMultiSelection = { fg = colors.lavender },

              -- Neotree
              NeoTreeDirectoryName = { fg = colors.lavender },
              NeoTreeDirectoryIcon = { fg = colors.lavender },
              NeoTreeFileName = { fg = colors.lavender },
              NeoTreeFileNameOpened = { fg = colors.lavender, italic = true },
              NeoTreeSymbolicLinkTarget = { fg = colors.lavender, italic = true },
              NeoTreeRootName = { fg = colors.lavender, bold = true },

              -- CMP
              CmpBorder = { fg = colors.lavender },
              CmpDocBorder = { fg = colors.mauve },
              CmpItemAbbrMatch = { fg = colors.pink },
              CmpItemAbbrMatchFuzzy = { fg = colors.mauve },
              CmpItemSelected = { bg = colors.lavender },

              -- Noti
              NotifyINFOBorder = { fg = colors.lavender },
            }
          end,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          notify = true,
          mini = true,
          noice = true,
          which_key = true,
          illuminate = true,
          leap = true,
          markdown = true,
          native_lsp = {
            enabled = true,
          },
        },
      })
    end,
    name = "catppuccin",
  },
  sonokai = {
    setup = function()
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_style = "andromeda"
      vim.g.sonokai_enable_italic = true
      vim.g.sonokai_diagnostic_text_highlight = true
    end,
    name = "sonokai",
  },
}

function M.set_theme(theme_name)
  local theme_to_load = theme_name or settings.colorscheme.default_theme
  local theme = M.themes[theme_to_load]
  if not theme then
    vim.notify("Theme '" .. theme_to_load .. "' not found! Using default", vim.log.levels.ERROR)
    theme = M.themes[settings.default_theme]
  end

  -- Load plugin if needed
  if theme.package then
    require("lazy").load({ plugins = { theme.package } })
  end

  -- Apply theme
  pcall(theme.setup)
  vim.cmd.colorscheme(theme.name)
  -- Highlight the current line number using the theme's color
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      local ok, catppuccin = pcall(require, "catppuccin.palettes")
      if ok then
        local color = catppuccin.get_palette().yellow
        vim.cmd("hi CursorLineNr guifg=" .. color .. " gui=bold")
      else
        vim.cmd("hi CursorLineNr guifg=#ffcc00 gui=bold") -- Default yellow if theme fails
      end
    end,
  })
end

function M.set_default_theme(theme_name)
  if not M.themes[theme_name] then
    vim.notify("Theme '" .. theme_name .. "' doesn't exist!", vim.log.levels.ERROR)
    return
  end

  -- Update in-memory settings
  settings.colorscheme.default_theme = theme_name

  -- Ensure config directory exists
  local config_dir = vim.fn.stdpath("config") .. "/lua/config"
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.fn.mkdir(config_dir, "p")
  end

  -- Create or update settings file
  local config_path = config_dir .. "/settings.lua"
  local content = string.format(
    [[
return {
  colorscheme = {
    default_theme = "%s",
  },
  -- Add other settings here if needed
}
]],
    theme_name
  )

  local fd = io.open(config_path, "w+")
  if fd then
    fd:write(content)
    fd:close()
    vim.notify("Default theme saved to " .. config_path)
  else
    vim.notify("Failed to save theme preference", vim.log.levels.ERROR)
  end

  -- Apply the theme immediately
  M.set_theme(theme_name)
end

return M
