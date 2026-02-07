---@diagnostic disable-next-line: undefined-global
local vim = vim -- use Neovim's injected global `vim` in this module

-- Shorthand for window/buffer/editor options
local opt = vim.opt

-- UI / layout
opt.number = true          -- show absolute line numbers
opt.numberwidth = 1        -- minimal width for number column
opt.cursorline = true      -- highlight the current line
opt.wrap = false           -- disable line wrapping
opt.scrolloff = 5          -- keep 5 lines visible above/below cursor
opt.sidescrolloff = 5      -- keep 5 columns visible left/right of cursor
opt.showmode = false       -- don't show mode since statusline handles it
opt.termguicolors = false  -- don't enable truecolor; use terminal colors
opt.laststatus = 3         -- global statusline for all windows
opt.signcolumn = "no"      -- hide the sign column by default
opt.mousemodel = "extend"  -- right-click extends selection
opt.cmdheight = 0          -- hide command line when not in use (Neovim 0.9+)
opt.history = 0            -- disable command-line history

opt.shortmess:append({ I = true }) -- skip Neovim intro message
opt.fillchars:append({ eob = " " }) -- hide ~ on empty lines

-- Indentation and tabs
opt.expandtab = true       -- insert spaces instead of tabs
opt.tabstop = 2            -- visual width of a tab character
opt.shiftwidth = 2         -- indentation width for >> and << and autoindent
opt.autoindent = true      -- copy indent from current line when starting a new one
opt.smartindent = true     -- smarter auto-indentation for code

-- Searching
opt.ignorecase = true      -- case-insensitive search by default
opt.smartcase = true       -- but make search case-sensitive if pattern has capitals
opt.incsearch = true       -- show matches as you type
opt.hlsearch = false       -- don't highlight all search matches by default

-- Window splitting behaviour
opt.splitbelow = true      -- open horizontal splits below
opt.splitright = true      -- open vertical splits to the right

-- Clipboard and mouse
opt.clipboard = "unnamedplus" -- use system clipboard by default
opt.mouse = "a"               -- enable mouse in all modes

-- Files and persistence
opt.undofile = true       -- persist undo history across sessions
opt.swapfile = false      -- don't use swap files
opt.backup = false        -- don't keep backup files
opt.writebackup = false   -- don't write a backup before overwriting a file
opt.confirm = true        -- ask for confirmation instead of failing on write

-- Timings / completion
opt.updatetime = 300             -- faster CursorHold and diagnostics updates
opt.timeoutlen = 500             -- timeout for mapped key sequences (ms)
opt.completeopt = { "menuone", "noselect" } -- better completion UX

-- Disable built-in providers 
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
