---@diagnostic disable-next-line: undefined-global
local vim = vim -- use Neovim's injected global `vim` in this module

local M = {}

-- Install lazy.nvim on first run and add it to the runtime path
function M.bootstrap()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- Clone lazy.nvim if it is not already present
    local out = vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      "https://github.com/folke/lazy.nvim.git", lazypath
    })
    if vim.v.shell_error ~= 0 then
      -- Show the error message and abort Neovim startup
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out,                            "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  -- Ensure lazy.nvim is loaded before other runtime paths
  vim.opt.rtp:prepend(lazypath)
end

return M
