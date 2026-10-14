# Windows Terminal color schemes

`schemes.json` contains color scheme objects for Windows Terminal. It is a JSON
array fragment, not a complete Windows Terminal `settings.json` file; Terminal
does not support importing scheme definitions from a separate file.

To install a scheme:

1. In Windows Terminal, open **Settings → Open JSON file**.
2. Copy the desired object from `schemes.json` into the existing `"schemes"`
   array in `settings.json` (create the array if it does not exist). Keep any
   existing schemes.
3. Set `"colorScheme"` under `"profiles.defaults"` to one of the scheme names:
   `Gruvbox Dark`, `Cobalt2`, `Dracula`, or `Nord`. You can also select it from
   **Settings → profile → Appearance → Color scheme**.

When updating a scheme here, copy the updated object into the Terminal settings
again. Avoid replacing the entire settings file, which may contain
machine-specific or automatically generated profile entries.
