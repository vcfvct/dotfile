local default_map_opt = { silent = true, noremap = true }

return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  nomarl_delete = vim.keymap.set("n", "d", '"_d', default_map_opt),
  nomarl_cut = vim.keymap.set("n", "x", '"_x', default_map_opt),
  nomarl_change = vim.keymap.set("n", "c", '"_c', default_map_opt),
  visual_delete = vim.keymap.set("v", "d", '"_d', default_map_opt),
  visual_paste = vim.keymap.set("v", "p", "pgvy", default_map_opt),
  format_json = vim.api.nvim_command "com! FormatJSON %!python3 -m json.tool",
  format_xml = vim.api.nvim_command 'com! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"',
  -- format_xml = vim.cmd("com! FormatXML :%!python3 -c \"import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())\""),
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
}