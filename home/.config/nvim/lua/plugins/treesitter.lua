return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Update parsers when the plugin is updated
  event = { "BufReadPost", "BufNewFile" }, -- Load when opening a file

  -- Options passed to the setup function
  opts = {
    -- Install parsers for current config (lua, vim) and Noice requirements (bash, regex)
    ensure_installed = {
      "bash",
      "regex",
      "lua",
      "vim",
      "markdown",
      "markdown_inline",
      "c_sharp",
      "go",
      "gomod",
      "javascript",
      "typescript",
      "python",
      "rust",
      "terraform",
      "hcl",
      "yaml",
      "json",
      "toml",
    },
    sync_install = false, -- Install parsers asynchronously
    auto_install = true,  -- Automatically install missing parsers
    highlight = {
      enable = true, -- Use Treesitter for syntax highlighting
      additional_vim_regex_highlighting = false, -- Disable standard vim syntax matching
    },
  },

  -- Safe configuration handler
  config = function(_, opts)
    -- Safely attempt to load the module to prevent startup errors during installation
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if ok then
      configs.setup(opts)
    end
  end,
}
