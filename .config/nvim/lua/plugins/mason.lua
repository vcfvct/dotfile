-- Customize Mason

local function is_windows_arm()
  if vim.fn.has "win32" ~= 1 then return false end
  local machine = (vim.uv.os_uname().machine or ""):lower()
  return machine:find("arm", 1, true) ~= nil or machine:find("aarch64", 1, true) ~= nil
end

-- TODO(woa): Mason has no win_arm64 builds for lua-language-server, stylua, or
-- tree-sitter-cli. Skip them on Windows on ARM until native packages exist; do
-- not fall back to win_x64 emulation.
local ensure_installed = {}
if not is_windows_arm() then
  ensure_installed = {
    -- install language servers
    "lua-language-server",
    -- install formatters
    "stylua",
    -- nvim-treesitter (main) needs the `tree-sitter` CLI on PATH
    "tree-sitter-cli",
  }
end

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = ensure_installed,
    },
  },
}
