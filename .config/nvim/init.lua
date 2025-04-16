-- TODO Commentaire de todo
-- Load core configuration
require('config.options').set_options()
require('config.lazy').setup_lazy()

-- Setup plugins
local opts = {}
local plugins = {
  { import = "plugins" },
}

require("lazy").setup(plugins, opts)

-- Load remaining configuration
require('config.colorscheme').set_theme()
require('config.keymaps').setup()
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  pattern = "*",
  command = "checktime",
})
-- Add this to your Neovim config file

-- Create a Neovim command to display LSP environment info
vim.api.nvim_create_user_command('PythonLSPInfo', function()
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local found = false
  
  for _, client in ipairs(clients) do
    if client.name == "pyright" or client.name == "pylsp" then
      found = true
      
      -- Print basic client info
      print("Python LSP: " .. client.name)
      print("ID: " .. client.id)
      
      -- Get Python path from client config
      local python_path = client.config.settings 
        and client.config.settings.python 
        and client.config.settings.python.pythonPath
      
      if python_path then
        print("Python Path: " .. python_path)
        
        -- Get Python version
        local handle = io.popen(python_path .. " --version 2>&1")
        local version = handle:read("*a"):gsub("\n", "")
        handle:close()
        print("Version: " .. version)
        
        -- Check if it's a Poetry environment
        local env_handle = io.popen(python_path .. " -c 'import sys; print(sys.prefix)'")
        local env_path = env_handle:read("*a"):gsub("\n", "")
        env_handle:close()
        
        print("Environment: " .. env_path)
        if env_path:match("poetry") then
          print("This appears to be a Poetry environment.")
        end
      else
        print("Using system Python")
      end
      
      -- Print workspace folders
      if client.config.workspace_folders then
        print("Workspace folders:")
        for _, folder in ipairs(client.config.workspace_folders) do
          print("  - " .. folder.name)
        end
      end
    end
  end
  
  if not found then
    print("No Python LSP is active in this buffer.")
  end
end, {})
