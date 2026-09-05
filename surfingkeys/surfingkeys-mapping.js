
const {
    aceVimMap,
    mapkey,
    imap,
    imapkey,
    iunmap,
    getClickableElements,
    vmapkey,
    map,
    unmap,
    vunmap,
    cmap,
    addSearchAlias,
    removeSearchAlias,
    tabOpenLink,
    readText,
    Clipboard,
    Front,
    Hints,
    Visual,
    RUNTIME
} = api;

// 'F' open new tab in backgroud
map("F", "gf");
// pin tab with 'gp'
map("gp", "<Alt-p>");

//map toggle last used tab to ctrl+`
map("<Ctrl-o>", "<Ctrl-6>")
//map mark key to 'M' to reduce accidental mark set
map("M", 'm');
unmap('m');
// h/l for history back/forward
map("h", "S");
map("l", "D");

map("#", '*'); // use '#' to search word under cursor in visual mode

// so ctrl-u can be used in vim editor with site like leetcode/hackerank etc.
iunmap("<Ctrl-u>");
// for code search in ADO
iunmap("<Ctrl-f>", /visualstudio.com/);
iunmap("<Ctrl-f>", /dev.azure.com/);
iunmap("<Ctrl-f>", /portal.microsoftgeneva.com/);


settings.blocklistPattern = /(((calendar|docs)\.google|typingclub|duolingo|haxball|udemy|portal\.azure)\.com|[^/]+\.portal\.azure\.net|(vscode|github).dev)/i

/** Style for Chromium browser

// -----------------------------------------------------------------------------------------------------------------------
// Change hints styles
// -----------------------------------------------------------------------------------------------------------------------
Hints.style("border: solid 3px #707070; color:#efe1eb; background: none; background-color: #707070;", "text");
Hints.style(" \
  font-family: Roboto, sans serif; \
  font-size: 13px; \
  font-weight: 400; \
  border: unset; \
  padding: 3px; \
  color: #ffffff; \
  background: unset; \
  background-color: #3d51f5; \
  //background-color: rgba(158, 57, 255, 0.19); \
");

// -----------------------------------------------------------------------------------------------------------------------
// Change search marks and cursor
// -----------------------------------------------------------------------------------------------------------------------
Visual.style('marks', 'background: unset; background-color: #9c39ff');
Visual.style('cursor', 'background: unset; background-color: #ff4081');

*/

// keep Tabs Threshold a sane number for 'shift-t'
settings.tabsThreshold = 9;

// editor theme: https://github.com/brookhong/Surfingkeys/issues/936#issuecomment-494894091
settings.theme = `
:root {
    --theme-ace-bg:#282828ab; /*Note the fourth channel, this adds transparency*/
    --theme-ace-bg-accent:#3c3836;
    --theme-ace-fg:#ebdbb2;
    --theme-ace-fg-accent:#7c6f64;
    --theme-ace-cursor:#928374;
    --theme-ace-select:#458588;
}
#sk_editor {
    height: 50% !important; /*Remove this to restore the default editor size*/
    background: var(--theme-ace-bg) !important;
}
.ace_dialog-bottom{
    border-top: 1px solid var(--theme-ace-bg) !important;
}
.ace-chrome .ace_print-margin, .ace_gutter, .ace_gutter-cell, .ace_dialog{
    background: var(--theme-ace-bg-accent) !important;
}
.ace-chrome{
    color: var(--theme-ace-fg) !important;
}
.ace_gutter, .ace_dialog {
    color: var(--theme-ace-fg-accent) !important;
}
.ace_cursor{
    color: var(--theme-ace-cursor) !important;
}
.normal-mode .ace_cursor{
    background-color: var(--theme-ace-cursor) !important;
    border: var(--theme-ace-cursor) !important;
}
.ace_marker-layer .ace_selection {
    background: var(--theme-ace-select) !important;
}
.sk_theme input {
    font-family: "Fira Code";
}
.sk_theme .url {
    font-size: 15px;
}
#sk_omnibarSearchResult li div.url {
    font-weight: normal;
}
.sk_theme .omnibar_timestamp {
    font-size: 11px;
    font-weight: bold;
}
.sk_theme .omnibar_visitcount {
    font-size: 11px;
    font-weight: bold;
}
body {
    font-family: "Fira Code", Consolas, "Liberation Mono", Menlo, Courier, monospace;
    font-size: 14px;
}
kbd {
    font: 11px "Fira Code", Consolas, "Liberation Mono", Menlo, Courier, monospace;
}
#sk_omnibarSearchArea .prompt, #sk_omnibarSearchArea .resultPage {
    font-size: 12px;
}
.sk_theme {
    background: #282a36;
    color: #f8f8f2;
}
.sk_theme tbody {
    color: #ff5555;
}
.sk_theme input {
    color: #ffb86c;
}
.sk_theme .url {
    color: #f1fa8c;
}
#sk_omnibarSearchResult ul li {
    background: #282a36;
}
#sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282a36;
}
.sk_theme .annotation {
    color: #6272a4;
}
.sk_theme .focused {
    background: #44475a !important;
}
.sk_theme kbd {
    background: #f8f8f2;
    color: #44475a;
}
.sk_theme .frame {
    background: #8178DE9E;
}
.sk_theme .omnibar_highlight {
    color: #8be9fd;
}
.sk_theme .omnibar_folder {
    color: #ff79c6;
}
.sk_theme .omnibar_timestamp {
    color: #bd93f9;
}
.sk_theme .omnibar_visitcount {
    color: #f1fa8c;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #282a36;
}
.sk_theme .prompt, .sk_theme .resultPage {
    color: #50fa7b;
}
.sk_theme .feature_name {
    color: #ff5555;
}
.sk_omnibar_middle #sk_omnibarSearchArea {
    border-bottom: 1px solid #282a36;
}
#sk_status {
    border: 1px solid #282a36;
}
#sk_richKeystroke {
    background: #282a36;
    box-shadow: 0px 2px 10px rgba(40, 42, 54, 0.8);
}
#sk_richKeystroke kbd .candidates {
    color: #ff5555;
}
#sk_keystroke {
    background-color: #282a36;
    color: #f8f8f2;
}
kbd {
    border: solid 1px #f8f8f2;
    border-bottom-color: #f8f8f2;
    box-shadow: inset 0 -1px 0 #f8f8f2;
}
#sk_frame {
    border: 4px solid #ff5555;
    background: #8178DE9E;
    box-shadow: 0px 0px 10px #DA3C0DCC;
}
#sk_banner {
    border: 1px solid #282a36;
    background: rgb(68, 71, 90);
}
div.sk_tabs_bg {
    background: #f8f8f2;
}
div.sk_tab {
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#6272a4), color-stop(100%,#44475a));
}
div.sk_tab_title {
    color: #f8f8f2;
}
div.sk_tab_url {
    color: #8be9fd;
}
div.sk_tab_hint {
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f1fa8c), color-stop(100%,#ffb86c));
    color: #282a36;
    border: solid 1px #282a36;
}
#sk_bubble {
    border: 1px solid #f8f8f2;
    color: #282a36;
    background-color: #f8f8f2;
}
#sk_bubble * {
    color: #282a36 !important;
}
div.sk_arrow[dir=down] div:nth-of-type(1) {
    border-top: 12px solid #f8f8f2;
}
div.sk_arrow[dir=up] div:nth-of-type(1) {
    border-bottom: 12px solid #f8f8f2;
}
div.sk_arrow[dir=down] div:nth-of-type(2) {
    border-top: 10px solid #f8f8f2;
}
div.sk_arrow[dir=up] div:nth-of-type(2) {
    border-bottom: 10px solid #f8f8f2;
}
`;
