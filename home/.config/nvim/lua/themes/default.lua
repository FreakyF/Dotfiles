local M = {}

-- Shared 16-color cterm palette for the theme
local palette = {
  colorNONE = "NONE",
}

---@type { [string]: integer|string }
for i = 0, 15 do
  palette["color" .. i] = i
end

-- Export palette so other modules (e.g. lualine, noice) can reuse it
M.palette = palette

-- Build lualine sections for a given mode color
local function mode_section(cterm)
  local bg = palette.colorNONE

  return {
    a = { fg = cterm, bg = bg, gui = "bold" },
    b = { fg = cterm, bg = bg },
    c = { fg = cterm, bg = bg },
  }
end

-- Lualine theme (cterm-only), keyed by editor mode
M.lualine = {
  normal   = mode_section(palette.color2),
  insert   = mode_section(palette.color3),
  visual   = mode_section(palette.color5),
  replace  = mode_section(palette.color1),
  command  = mode_section(palette.color4),
  inactive = mode_section(palette.color8),
}

-- Alias for command-mode colors (for reuse elsewhere)
M.command = M.lualine.command

return M
