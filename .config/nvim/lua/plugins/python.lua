---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      -- For project debugging, prefer the repo venv; install debugpy there:
      --   uv add --dev debugpy
      -- or: source .venv/bin/activate && python -m pip install debugpy
      local function find_python()
        local env = vim.env.VIRTUAL_ENV
        if env and env ~= "" then
          local venv_python = env .. "/bin/python"
          if vim.fn.filereadable(venv_python) == 1 then return venv_python end
        end

        local cwd = vim.fn.getcwd()
        local local_venv = cwd .. "/.venv/bin/python"
        if vim.fn.filereadable(local_venv) == 1 then return local_venv end

        local uv_venv = cwd .. "/.venv/.python"
        if vim.fn.filereadable(uv_venv) == 1 then return uv_venv end

        local python = vim.fn.exepath "python3"
        if python ~= "" then return python end

        python = vim.fn.exepath "python"
        if python ~= "" then return python end

        return "python3"
      end

      require("dap-python").setup(find_python())
    end,
  },
}
