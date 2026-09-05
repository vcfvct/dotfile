-- lazy.nvim auto-detects the setup module from the plugin name when `opts` is set.
-- That lookup fails for `zbirenbaum/copilot.lua` (name ends in `.lua`), especially on
-- Windows, and pops: "Lua module not found for config of copilot.lua".
---@type LazySpec
return {
  "zbirenbaum/copilot.lua",
  main = "copilot",
  config = function(_, opts) require("copilot").setup(opts) end,
}
