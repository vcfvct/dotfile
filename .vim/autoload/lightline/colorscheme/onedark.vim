" ============================================================================
" File: onedark.vim
" Description: onedark colorscheme for Lightline (itchyny/lightline.vim)
" Author: novadev94 <novadev94@gmail.com>
" Source: https://github.com/novadev94/lightline-onedark
" Last Modified: 06 Oct 2016
" ===========================================================================

let s:bold = get(g:, 'lightline#onedark#disable_bold_style', 0) ? '' : 'bold'

" Colour codes that are used in the original onedark.vim theme
let s:light_red     = [ '#e06c75', 204 ]
let s:dark_red      = [ '#be5046', 196 ]
let s:green         = [ '#98c379', 114 ]
let s:blue          = [ '#61afef', 39 ]
let s:cyan          = [ '#56b6c2', 38 ]
let s:magenta       = [ '#c678dd', 170 ]
let s:light_yellow  = [ '#e5c07b', 180 ]
let s:dark_yellow   = [ '#d19a66', 173 ]

let s:black         = [ '#282c34', 235 ]
let s:white         = [ '#abb2bf', 145 ]
let s:comment_grey  = [ '#5c6370', 59 ]
let s:gutter_grey   = [ '#636d83', 238 ]
let s:cursor_grey   = [ '#2c323c', 236 ]
let s:visual_grey   = [ '#3e4452', 237 ]
let s:menu_grey     = s:visual_grey
let s:special_grey  = [ '#3b4048', 238 ]
let s:vertsplit     = [ '#181a1f', 59 ]

let s:tab_color     = s:blue
let s:normal_color  = s:blue
let s:insert_color  = s:green
let s:replace_color = s:light_red
let s:visual_color  = s:light_yellow
let s:active_bg     = s:visual_grey
let s:inactive_bg   = s:special_grey

let s:p = {'normal': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'inactive': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:black, s:normal_color, s:bold ], [ s:white, s:active_bg ] ]
let s:p.normal.right    = [ [ s:black, s:normal_color ], [ s:white, s:active_bg ] ]
let s:p.normal.middle   = [ [ s:normal_color, s:cursor_grey ] ]

let s:p.insert.left     = [ [ s:black, s:insert_color, s:bold ], [ s:white, s:active_bg ] ]
let s:p.insert.right    = [ [ s:black, s:insert_color ], [ s:white, s:active_bg ] ]
let s:p.insert.middle   = [ [ s:insert_color, s:cursor_grey ] ]

let s:p.replace.left    = [ [ s:black, s:replace_color, s:bold ], [ s:white, s:active_bg ] ]
let s:p.replace.right   = [ [ s:black, s:replace_color ], [ s:white, s:active_bg ] ]
let s:p.replace.middle  = [ [ s:replace_color, s:cursor_grey ] ]

let s:p.visual.left     = [ [ s:black, s:visual_color, s:bold ], [ s:white, s:active_bg ] ]
let s:p.visual.right    = [ [ s:black, s:visual_color ], [ s:white, s:active_bg ] ]
let s:p.visual.middle   = [ [ s:visual_color, s:cursor_grey ] ]

let s:p.inactive.left   = [ [ s:white, s:inactive_bg ], [ s:white, s:inactive_bg ] ]
let s:p.inactive.right  = [ [ s:white, s:inactive_bg ], [ s:white, s:inactive_bg ] ]
let s:p.inactive.middle = [ [ s:white, s:inactive_bg ] ]

let s:p.tabline.left    = [ [ s:gutter_grey, s:cursor_grey ] ]
let s:p.tabline.right   = [ [ s:tab_color, s:cursor_grey ] ]
let s:p.tabline.middle  = [ [ s:black, s:black ] ]
let s:p.tabline.tabsel  = [ [ s:black, s:blue, s:bold ] ]
let s:p.tabline.bufsel  = [ [ s:tab_color, s:visual_grey ] ]
let s:p.tabline.tabsep  = [ [ s:white, s:cursor_grey ] ]

let s:p.normal.error    = [ [ s:black, s:light_red ] ]
let s:p.normal.warning  = [ [ s:black, s:light_yellow ] ]

let g:lightline#colorscheme#onedark#palette = lightline#colorscheme#flatten(s:p)

