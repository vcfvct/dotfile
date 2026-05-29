---@type LazySpec
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "python" })
      opts.handlers = opts.handlers or {}
      opts.handlers.python = function() end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, { "debugpy" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local debugpy = vim.fn.exepath "debugpy-adapter"
      if debugpy == "" then debugpy = vim.fn.exepath "uv" end
      if debugpy == "" then debugpy = vim.fn.exepath "python3" end
      if debugpy == "" then debugpy = vim.fn.exepath "python" end
      require("dap-python").setup(debugpy)
    end,
  },
}
