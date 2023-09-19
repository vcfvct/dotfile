-- use powershell as default shell on Windows
if jit.os == "Windows" then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
end

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

  -- alternative is to use jq with: %!jq .
  format_json = vim.api.nvim_command "com! FormatJSON %!python3 -m json.tool",
  -- The ‘%’ symbol tells neovim to apply the command to the entire buffer, which is the current file you are editing.
  -- The ‘!’ symbol tells neovim to run an external command, which is jq in this case.
  -- The ‘-r’ option tells jq to output raw strings instead of JSON texts. This means that jq will not add quotes or backslashes to the output, which are usually needed for valid JSON.
  -- The ‘–tab’ option tells jq to use tabs instead of spaces for indentation. This means that jq will indent each level of the JSON object with a tab character, which can make the output more readable and structured.
  -- The ‘fromjson’ function tells jq to parse the input as a JSON string and output it as a JSON object. This means that jq will convert the input, which is a single line of escaped JSON string, into a multi-line JSON object with proper formatting and indentation.
  unescape_json = vim.api.nvim_command "com! UnescapeJSON %!jq -r --tab 'fromjson'",
  format_xml = vim.api.nvim_command 'com! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"',
  file_type = vim.api.nvim_command "au BufNewFile,BufRead *.sap,*.omap setf json",
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
  {
    -- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/completion/tabnine-nvim/init.lua
    "codota/tabnine-nvim",
    name = "tabnine",
    build = vim.loop.os_uname().sysname == "Windows_NT" and "pwsh.exe -file .\\dl_binaries.ps1" or "./dl_binaries.sh",
    cmd = { "TabnineStatus", "TabnineDisable", "TabnineEnable", "TabnineToggle" },
    event = "User AstroFile",
    opts = { accept_keymap = "<C-f>" },
  }
}
