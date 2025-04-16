-- lua/config/poetry.lua

local M = {}

M.get_python_poetry_path = function(root_dir)
  -- Traverse upwards to look for pyproject.toml or .git folder (Git root)
  local current_dir = root_dir
  while current_dir and current_dir ~= "/" do
    -- Check if the pyproject.toml exists in this directory (Poetry project root)
    if vim.fn.filereadable(current_dir .. "/pyproject.toml") == 1 then
      -- If pyproject.toml found, try to get the Poetry venv path
      local poetry_venv = vim.fn.trim(vim.fn.system("cd " .. current_dir .. " && poetry env info -p 2>/dev/null"))
      if poetry_venv ~= "" then
        return poetry_venv .. "/bin/python"
      end
    end
    -- Traverse to the parent directory
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end
  return nil  -- Return nil if no Poetry environment found
end

return M

