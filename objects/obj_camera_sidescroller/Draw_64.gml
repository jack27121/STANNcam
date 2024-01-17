//chooses pixel font or hires font
if(gui_hires){
	draw_set_font(f_hires);
	var _offset = 45;
	var _outline_width = 4;
	var _precision = 16;
	draw_set_color(c_white);
} else {
	draw_set_font(f_pixel);
	var _offset = 8;
	var _outline_width = 1;
	var _precision = 8;
	draw_set_color(c_white);
}

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1, 0, "[arrow keys] move character", _outline_width, _precision);
draw_text_outline(1, _offset * 2, "[ALT] toggle hi-res GUI", _outline_width, _precision);
draw_text_outline(1, _offset * 4, "[RMB] / [SCRL WHEEL] " + string(zoom_text), _outline_width, _precision);
var _constrained = (cam1.room_constrain) ? "camera constrained to room" : "camera not constrained to room";
draw_text_outline(1, _offset * 5, "[CTRL] " + _constrained, _outline_width, _precision);
var _debug = (cam1.debug_draw) ? "debug draw on" : "debug draw off";
draw_text_outline(1, _offset * 6, "[SHIFT] " + _debug, _outline_width, _precision);
draw_text_outline(1, _offset * 7, "[F] camera shake", _outline_width, _precision);
draw_text_outline(1, _offset * 8, "[P] camera paused: " + (cam1.get_paused() ? "ON" : "OFF"), _outline_width, _precision);
draw_text_outline(1, _offset * 9, "[Tab] camera speed " + string(cam1.spd), _outline_width, _precision);
draw_text_outline(1, _offset * 10, "[1 & 2 & 3] to switch between example rooms", _outline_width, _precision);

//draw current resolution text
draw_set_halign(fa_right);
draw_text_outline(global.gui_w - 1, 0, "Game size: " + string(global.game_w) + " x " + string(global.game_h), _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset , "Resolution: " + string(global.res_w) + " x " + string(global.res_h) + " [F1]", _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset * 2, "GUI resolution: " + string(global.gui_w) + " x " + string(global.gui_h) + " [F2]", _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset * 3, "Keep aspect ratio: " + (stanncam_get_keep_aspect_ratio() ? "ON" : "OFF") + " [F3]", _outline_width, _precision);

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

draw_text_outline(global.gui_w - 1, _offset * 4, "window mode: " + _window_mode_text + " [F4]", _outline_width, _precision);
draw_text_outline(global.gui_w - 1, _offset * 5, "split-screen: " + (split_screen ? "ON" : "OFF") + " [F5]", _outline_width, _precision);
