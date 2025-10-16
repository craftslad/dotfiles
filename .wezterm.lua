local wezterm = require("wezterm")

local M = {}

M.spec = {
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	window_background_opacity = 1.0,
	macos_window_background_blur = 10,

	font = wezterm.font_with_fallback({ "Lilex Nerd Font" }),
	font_size = 18,

	scrollback_lines = 10000,

	colors = {
		foreground = "#cdcdcd",
		background = "#141415",

		cursor_bg = "#cdcdcd",
		cursor_fg = "#141415",
		cursor_border = "#cdcdcd",

		selection_fg = "#cdcdcd",
		selection_bg = "#252530",

		scrollbar_thumb = "#252530",
		split = "#252530",

		ansi = {
			"#252530",
			"#d8647e",
			"#7fa563",
			"#f3be7c",
			"#6e94b2",
			"#bb9dbd",
			"#aeaed1",
			"#cdcdcd",
		},
		brights = {
			"#606079",
			"#e08398",
			"#99b782",
			"#f5cb96",
			"#8ba9c1",
			"#c9b1ca",
			"#bebeda",
			"#d7d7d7",
		},
	},
}

return M.spec
