---@diagnostic disable-next-line: undefined-global
local vim = vim -- use Neovim's injected global `vim` in this module

-- Shorthand for defining keymaps
local map = vim.keymap.set

-- Disable command-line window and macro recording keys
map("n", "q:", "<Nop>")
map({ "n", "x" }, "q", "<Nop>")
map({ "n", "x" }, "@", "<Nop>")
map("n", "Q", "<Nop>")

-- Disable F1 (help) in all common modes
map({ "n", "i", "v", "x", "c" }, "<F1>", "<Nop>", { silent = true })

-- Run :TrimWhitespace on the entire buffer
map("n", "<C-l>", "<cmd>TrimWhitespace<CR>", {
  silent = true,
  desc = "Trim trailing whitespace (buffer)",
})

-- Run :TrimWhitespace on the current visual selection
map("x", "<C-l>", ":'<,'>TrimWhitespace<CR>", {
  silent = true,
  desc = "Trim trailing whitespace (selection)",
})

-- Yank entire buffer to system clipboard
map("n", "gy", "<cmd>%y+<CR>", { 
  desc = "Yank whole file to system clipboard",
})
