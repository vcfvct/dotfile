# Windows Terminal color schemes

`schemes.json` contains color scheme objects for Windows Terminal. It is a JSON
array fragment, not a complete Windows Terminal `settings.json` file; Terminal
does not support importing scheme definitions from a separate file.

To install the schemes automatically, run this from the repository root in
PowerShell:

```powershell
pwsh -File .\windows-terminal\Install-Schemes.ps1
```

The script finds the Windows Terminal settings file (or accepts an explicit
path with `-SettingsPath`), appends schemes that are not already present, and
creates a timestamped backup before changing the file. If `settings.json` has
no `"schemes"` array, add `"schemes": []` and run the script again.

To install manually, open **Windows Terminal → Settings → Open JSON file** and
copy the desired objects from `schemes.json` into the existing `"schemes"`
array. Keep any existing schemes. Set `"colorScheme"` under
`"profiles.defaults"` to `Gruvbox Dark`, `Cobalt2`, `Dracula`, or `Nord`, or
select one from **Settings → profile → Appearance → Color scheme**.

The script only updates the schemes array; it does not change your active
profile's selected scheme.
