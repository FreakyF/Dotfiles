---@diagnostic disable-next-line: undefined-global
local vim = vim

-- Noice.nvim: enhanced UI for messages, cmdline, and notifications
return {
  "folke/noice.nvim",
  event = "VeryLazy", -- defer loading until after startup
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },

  -- Base Noice configuration (can be extended in config)
  opts = {
    messages = {
      enabled = true,
      view = "mini",
      view_error = "mini",
      view_warn = "mini",
      view_history = "messages",
      view_search = "mini",
    },
    -- Override default LSP markdown formatting to be handled by Noice
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    notify = {
      enabled = true,
      view = "mini",
    },
    views = {
      mini = { format = "notify" },
    },
    routes = {
      { filter = { event = "notify" }, view = "mini" },
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = false,        -- keep default search UI placement
      command_palette = true,       -- enable command palette-style UI
      long_message_to_split = true, -- send long messages to a split
    },
  },

  config = function(_, opts)
    local api = vim.api
    local tbl_deep_extend = vim.tbl_deep_extend

    -- When opened from lazy.nvim, start with a clean message history
    if vim.bo.filetype == "lazy" then
      vim.cmd("messages clear")
    end

    -- Ensure tables exist before extending them
    opts.routes = opts.routes or {}
    opts.views = opts.views or {}
    opts.cmdline = opts.cmdline or {}

    -- Route confirm prompts through a dedicated Noice "confirm" view
    table.insert(opts.routes, 1, {
      filter = { event = "msg_show", kind = "confirm" },
      view = "confirm",
    })

    -- Convenience helper to merge view configuration
    local function extend_view(name, cfg)
      opts.views[name] = tbl_deep_extend("force", opts.views[name] or {}, cfg)
    end

    -- Style for confirmation dialogs
    extend_view("confirm", {
      win_options = {
        winhighlight = {
          Normal = "NoiceConfirm",
          NormalFloat = "NoiceConfirm",
          FloatBorder = "NoiceConfirmBorder",
          FloatTitle = "NoiceConfirmTitle",
          MoreMsg = "NoiceConfirmText",
        },
      },
    })

    -- Style for input prompts
    extend_view("input", {
      win_options = {
        winhighlight = {
          Normal = "NoiceInput",
          NormalFloat = "NoiceInput",
          FloatBorder = "NoiceInputBorder",
          FloatTitle = "NoiceInputTitle",
        },
      },
    })

    -- Disable syntax highlighting in the cmdline renderer
    opts.cmdline.format = tbl_deep_extend("force", {
      cmdline = { lang = false },
      search_down = { lang = false },
      search_up = { lang = false },
      filter = { lang = false },
      lua = { lang = false },
    }, opts.cmdline.format or {})

    -- Style for the popup cmdline, including attached message highlights
    extend_view("cmdline_popup", {
      win_options = {
        winhighlight = {
          Normal = "NoiceCmdlinePopup",
          NormalNC = "NoiceCmdlinePopup",
          NormalFloat = "NoiceCmdlinePopup",
          FloatBorder = "NoiceCmdlinePopupBorder",

          MsgArea = "NoiceCmdlinePopup",
          MsgSeparator = "NoiceCmdlinePopup",
          MoreMsg = "NoiceCmdlinePopup",
          ModeMsg = "NoiceCmdlinePopup",
          Question = "NoiceCmdlinePopup",
          WarningMsg = "NoiceCmdlinePopup",
          ErrorMsg = "NoiceCmdlinePopup",

          Search = "NoiceCmdlinePopup",
          IncSearch = "NoiceCmdlinePopup",

          Statement = "NoiceCmdlinePopup",
          Operator = "NoiceCmdlinePopup",
          String = "NoiceCmdlinePopup",
          Character = "NoiceCmdlinePopup",
          Number = "NoiceCmdlinePopup",
          Boolean = "NoiceCmdlinePopup",
          Identifier = "NoiceCmdlinePopup",
          Function = "NoiceCmdlinePopup",
          Keyword = "NoiceCmdlinePopup",
          Constant = "NoiceCmdlinePopup",
          PreProc = "NoiceCmdlinePopup",
          Type = "NoiceCmdlinePopup",
          Special = "NoiceCmdlinePopup",
          Underlined = "NoiceCmdlinePopup",
          Todo = "NoiceCmdlinePopup",
        },
      },
    })

    -- Apply Noice configuration
    require("noice").setup(opts)

    -- Adapt Noice highlights to the theme's cterm palette
    local default = require("themes.default")
    local P = (default and default.palette) or {}

    local function sethl(group, col)
      if col then
        api.nvim_set_hl(0, group, { ctermfg = col, ctermbg = P.colorNONE })
      end
    end

    -- Basic message-related highlight groups
    for _, group in ipairs({
      "NoiceMini",
      "NoiceMiniBorder",
      "MsgArea",
      "MsgSeparator",
      "MoreMsg",
      "ModeMsg",
      "Question",
    }) do
      sethl(group, P.color8)
    end

    sethl("WarningMsg", P.color3)
    sethl("ErrorMsg", P.color1)

    -- Search and popupmenu selection background
    if P.color4 then
      api.nvim_set_hl(0, "Search", { ctermbg = P.color4 })
      api.nvim_set_hl(0, "IncSearch", { ctermbg = P.color4 })
      api.nvim_set_hl(0, "NoicePopupmenuSelected", { ctermbg = P.color4 })
    end

    -- Map Noice log levels to theme colors
    local level_map = {
      NoiceFormatLevelInfo = P.color8,
      NoiceFormatLevelWarn = P.color3,
      NoiceFormatLevelError = P.color1,
      NoiceFormatLevelDebug = P.color4,
      NoiceFormatLevelTrace = P.color8,
      NoiceFormatLevelOff = P.color8,
    }
    for group, col in pairs(level_map) do
      sethl(group, col)
    end

    -- Base styling for cmdline-related highlights
    local base = { ctermfg = P.color4, ctermbg = P.colorNONE }
    local base_bold = vim.tbl_extend("force", base, { bold = true })

    for _, group in ipairs({
      "NoiceCmdline",
      "NoiceCmdlineIcon",
      "NoiceCmdlineIconCalculator",
      "NoiceCmdlineIconCmdline",
      "NoiceCmdlineIconFilter",
      "NoiceCmdlineIconHelp",
      "NoiceCmdlineIconIncRename",
      "NoiceCmdlineIconInput",
      "NoiceCmdlineIconLua",
      "NoiceCmdlineIconSearch",
      "NoiceCmdlinePopup",
      "NoiceCmdlinePopupBorder",
      "NoiceCmdlinePopupBorderCalculator",
      "NoiceCmdlinePopupBorderCmdline",
      "NoiceCmdlinePopupBorderFilter",
      "NoiceCmdlinePopupBorderHelp",
      "NoiceCmdlinePopupBorderIncRename",
      "NoiceCmdlinePopupBorderInput",
      "NoiceCmdlinePopupBorderLua",
      "NoiceCmdlinePopupBorderSearch",
    }) do
      api.nvim_set_hl(0, group, base)
    end

    api.nvim_set_hl(0, "NoiceCmdlinePopupTitle", base_bold)
    api.nvim_set_hl(0, "NoiceCmdlinePrompt", base_bold)

    -- Confirm dialog styling
    api.nvim_set_hl(0, "NoiceConfirm", base)
    api.nvim_set_hl(0, "NoiceConfirmBorder", base)
    api.nvim_set_hl(0, "NoiceConfirmText", base)
    api.nvim_set_hl(0, "NoiceConfirmTitle", base_bold)

    -- Input popup styling
    api.nvim_set_hl(0, "NoiceInput", base)
    api.nvim_set_hl(0, "NoiceInputBorder", base)
    api.nvim_set_hl(0, "NoiceInputIcon", base)
    api.nvim_set_hl(0, "NoiceInputTitle", base_bold)
    api.nvim_set_hl(0, "NoiceInputPrompt", base)
  end,
}
