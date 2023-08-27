-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local maps = {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- mappings seen under group name "Buffer"
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },
    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    ["<leader>rp"] = { ":%s/", desc = "replace" },
    d = { '"_d' },
    x = { '"_x' },
    c = { '"_c' },
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  v = {
    d = { '"_d' },
    p = { 'pgvy' },
  }
}

maps.n["<F12>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
maps.t["<F12>"] = maps.n["<F12>"]
maps.n["<C-n>"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
maps.n["<C-g>"] = {
  function()
    require("telescope.builtin").live_grep {
      additional_args = function(args) return vim.list_extend(args, { "--hidden" }) end,
    }
  end,
  desc = "Find words in all files",
}
maps.n["<C-p>"] = { function() require("telescope.builtin").find_files { hidden = true } end, desc = "Find words" }

return maps
