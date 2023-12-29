var _outline_width = 1;
var _precision = 8;
var _offset = 10;

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1, 0, "[RMB] Zoom amount: " + string(zoom_text), _outline_width, _precision);
draw_text_outline(1, _offset * 1, "[F] camera shake", _outline_width, _precision);
draw_text_outline(1, _offset * 2, "[1 & 2 & 3] to switch", _outline_width, _precision);
draw_text_outline(1, _offset * 3, "between example rooms", _outline_width, _precision);

//draw current resolution text
draw_set_halign(fa_right);
draw_text_outline(global.gui_w - 1, 0, "Game size: " + string(global.game_w) + " x " + string(global.game_h), _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset * 1, "Resolution: " + string(global.res_w) + " x " + string(global.res_h) + " [F1]", _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset * 2, "Keep aspect ratio: " + string(stanncam_get_keep_aspect_ratio()) + " [F3]", _outline_width, _precision);
var _window_mode_text = "";
switch (global.window_mode) {
	case STANNCAM_WINDOW_MODE.WINDOWED:
		_window_mode_text = "windowed";
		break;
	case STANNCAM_WINDOW_MODE.FULLSCREEN:
		_window_mode_text = "fullscreen";
		break;
	case STANNCAM_WINDOW_MODE.BORDERLESS:
		_window_mode_text = "borderless";
		break;
}

draw_text_outline(global.gui_w - 1, _offset * 3, $"window mode: {_window_mode_text} [F4]", _outline_width, _precision);
