local function isWindows()
  return jit.os == "Windows"
end

return {
  {
    "mfussenegger/nvim-dap",
    -- no official support for windows yet, https://github.com/AstroNvim/AstroNvim/issues/2229
    enabled = function() return not isWindows() end,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", config = true },
    },
    config = function()
      if isWindows() then
        return
      end
      local dap = require "dap"
      require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter", -- As I'm using mason, this will be in the path
          args = { "${port}" },
        }
      }

      for _, language in ipairs { "typescript", "javascript" } do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
