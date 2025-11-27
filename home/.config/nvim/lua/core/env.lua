---@diagnostic disable-next-line: undefined-global
local vim = vim -- use Neovim's injected global `vim` in this module

local M = {}

-- Memoized result of the low-color console check
local cached_result

-- Detect whether we are running in a low-color console using an external helper
function M.is_low_color_console()
  -- Return cached value if we've already checked
  if cached_result ~= nil then
    return cached_result
  end

  -- If the helper script is not available, assume a normal color environment
  if vim.fn.executable("is-low-color-console.sh") ~= 1 then
    cached_result = false
    return cached_result
  end

  -- Run the helper and cache the result based on its exit status
  vim.fn.system({ "is-low-color-console.sh" })
  cached_result = (vim.v.shell_error == 0)

  return cached_result
end

return M
