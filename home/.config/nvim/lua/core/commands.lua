---@diagnostic disable-next-line: undefined-global
local vim = vim -- use Neovim's injected global `vim` in this module

-- Local shortcuts for commonly used vim APIs
local api, fn, log, notify = vim.api, vim.fn, vim.log, vim.notify

-- Simple pluralization helper: plural(1, "line") => "line", plural(2, "line") => "lines"
local function plural(n, one, many)
  return n == 1 and one or (many or (one .. "s"))
end

-- :TrimWhitespace
-- Remove trailing whitespace in the current buffer or a selected range
api.nvim_create_user_command("TrimWhitespace", function(opts)
  local bufnr = api.nvim_get_current_buf()
  local view = fn.winsaveview() -- remember cursor and window state

  local start_line, end_line, scope
  if opts.range == 0 then
    -- No range given: operate on the whole buffer
    start_line, end_line, scope = 0, api.nvim_buf_line_count(bufnr), "buffer"
  else
    -- Range given: operate only on the selected lines
    start_line, end_line, scope = opts.line1 - 1, opts.line2, "selection"
  end

  local lines = api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  local changed, removed_chars = 0, 0
  for i, line in ipairs(lines) do
    local stripped = line:gsub("%s+$", "") -- strip trailing whitespace
    if stripped ~= line then
      removed_chars = removed_chars + (#line - #stripped)
      lines[i] = stripped
      changed = changed + 1
    end
  end

  if changed > 0 then
    api.nvim_buf_set_lines(bufnr, start_line, end_line, false, lines)
  end

  fn.winrestview(view) -- restore cursor and window state

  local msg
  if changed == 0 then
    msg = ("No trailing whitespaces in %s."):format(scope)
  else
    msg = ("Trimmed %d %s on %d %s in %s."):format(
      removed_chars, plural(removed_chars, "character"),
      changed, plural(changed, "line"),
      scope
    )
  end

  notify(msg, log.levels.INFO)
end, { range = true })
