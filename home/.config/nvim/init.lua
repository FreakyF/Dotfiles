---@diagnostic disable-next-line: undefined-global
local vim = vim

local env = require("core.env")

-- Global leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core editor configuration (options, commands, keymaps)
local function load_core()
  require("core.options")
  require("core.commands")
  require("core.keymaps")
end

-- In low-color consoles, skip plugin manager and only load core settings
if env.is_low_color_console() then
  load_core()
  return
end

-- Ensure lazy.nvim is installed and added to the runtime path
require("core.bootstrap").bootstrap()

-- Initialize lazy.nvim plugin manager if available
local ok, lazy = pcall(require, "lazy")
if ok then
  lazy.setup({
    spec = {
      { import = "plugins" }, -- load plugin specs from lua/plugins/*
    },
    rocks = {
      enabled = false, -- kills luarocks/herorocks errors
    },
    checker = {
      enabled = true, -- periodically check for plugin updates
    },
  })
else
  vim.api.nvim_err_writeln("[init] lazy.nvim not found")
end

-- Load core configuration after plugins are set up
load_core()
