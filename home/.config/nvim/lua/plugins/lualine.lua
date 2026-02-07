-- Lualine statusline plugin configuration
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Shared theme and palette definitions
    local default = require("themes.default")

    -- Git diff summary using theme colors
    local diff_component = {
      "diff",
      symbols = {
        added = " ",
        modified = " ",
        removed = " ",
      },
      diff_color = {
        added = { fg = default.palette.color2 },
        modified = { fg = default.palette.color3 },
        removed = { fg = default.palette.color1 },
      },
    }

    -- Encoding and file format indicators (uppercase, no icons)
    local encoding_components = {
      { "encoding",   icons_enabled = false, fmt = string.upper },
      { "fileformat", icons_enabled = false, fmt = string.upper },
    }

    -- Git branch indicator
    local branch_component = { "branch", icon = "" }

    require("lualine").setup({
      -- Global lualine options
      options = {
        theme = default.lualine,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = {}, winbar = {} },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },

      -- Layout for active windows
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = encoding_components,
        lualine_y = {
          branch_component,
          diff_component,
        },
        lualine_z = {},
      },

      -- Layout for inactive windows (mirrors active layout)
      inactive_sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = encoding_components,
        lualine_y = {
          branch_component,
          diff_component,
        },
        lualine_z = {},
      },

      -- Extra components (unused)
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
