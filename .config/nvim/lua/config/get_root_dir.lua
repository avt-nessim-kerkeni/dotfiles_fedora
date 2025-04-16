-- lua/config/get_root_dir.lua
local M = {}

-- Function to check if a directory is a git repository
local function is_git_repo(dir)
  local handle = io.popen('git -C ' .. dir .. ' rev-parse --is-inside-work-tree 2>/dev/null')
  local result = handle:read("*a")
  handle:close()
  return result:match("true") ~= nil
end

-- Function to get the root directory
function M.get_root_dir()
  local current_dir = vim.fn.getcwd()
  -- Check if the current directory or any parent is a git repo
  if is_git_repo(current_dir) then
    return current_dir
  end

  -- Check parent directories if the current one is not a Git repo
  local parent_dir = current_dir
  while parent_dir ~= "/" do
    parent_dir = vim.fn.fnamemodify(parent_dir, ":h") -- Go to the parent directory
    if is_git_repo(parent_dir) then
      return parent_dir
    end
  end

  -- If no Git repo found, check if it's $HOME or fallback to current directory
  local home_dir = vim.fn.expand("~")
  if current_dir == home_dir or parent_dir == home_dir then
    return current_dir
  end

  -- Default: return the current directory as the root dir
  return current_dir
end

return M

