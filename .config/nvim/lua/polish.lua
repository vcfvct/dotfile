-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Format the whole buffer as JSON with Python's `json.tool`
-- alternative is to use jq with: `%!jq .`
vim.api.nvim_create_user_command(
  "FormatJSON",
  "%!python3 -m json.tool",
  { desc = "Pretty print the buffer as JSON", bar = true }
)

-- Turn a single line of escaped JSON string into a formatted, multi-line JSON object.
-- The `%` applies the command to the entire buffer, `!` filters it through an external command.
-- `-r` outputs raw strings instead of JSON texts (no added quotes/backslashes).
-- `--tab` indents with tabs instead of spaces.
-- `fromjson` parses the input as a JSON string and outputs it as a JSON object.
vim.api.nvim_create_user_command(
  "UnescapeJSON",
  "%!jq -r --tab 'fromjson'",
  { desc = "Unescape a JSON string buffer into a JSON object", bar = true }
)

-- Format the whole buffer as XML with Python's `xml.dom.minidom`
vim.api.nvim_create_user_command(
  "FormatXML",
  [[%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"]],
  { desc = "Pretty print the buffer as XML", bar = true }
)

-- NOTE: `*.sap`/`*.omap` are detected as `json` through `astrocore.opts.filetypes` in
-- `lua/plugins/astrocore.lua`, which is the AstroNvim way of calling `vim.filetype.add`.
