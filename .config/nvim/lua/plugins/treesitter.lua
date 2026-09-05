-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true, -- enable/disable treesitter based highlighting
      indent = true, -- enable/disable treesitter based indentation
      auto_install = true, -- enable/disable automatic installation of detected languages
      -- TODO(woa): Mason has no win_arm64 tree-sitter-cli; skip auto-install on ARM.
      auto_install_cli = not (vim.fn.has "win32" == 1 and (vim.uv.os_uname().machine or ""):lower():find "arm"),
      ensure_installed = {
        "lua",
        "vim",
        "markdown",
        "markdown_inline",
        "html",
        "yaml",
        "latex",
        -- add more arguments for adding more treesitter parsers
      },
    },
  },
}
