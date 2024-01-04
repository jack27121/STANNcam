/// @function stanncam_init
/// @description set game dimensions, display resolution, and gui dimensions, it's the same as game scale by default
/// @param {Real} _game_w
/// @param {Real} _game_h
/// @param {Real} [_resolution_w=_game_w]
/// @param {Real} [_resolution_h=_game_h]
/// @param {Real} [_gui_w=_game_w]
/// @param {Real} [_gui_h=_game_h]
/// @param {Real} [_window_mode=STANNCAM_WINDOW_MODE.WINDOWED]
function stanncam_init(_game_w, _game_h, _resolution_w=_game_w, _resolution_h=_game_h, _gui_w=_game_w, _gui_h=_game_h, _window_mode=STANNCAM_WINDOW_MODE.WINDOWED){
	
	//if one already exists it is destroyed
	if(instance_exists(__obj_stanncam_manager)) instance_destroy(__obj_stanncam_manager);
	
	instance_create_depth(0, 0, 0, __obj_stanncam_manager);
	
	global.stanncams = array_create(8, -1);
	global.game_w = _game_w;
	global.game_h = _game_h;
	global.gui_w = _gui_w;
	global.gui_h = _gui_h;
	global.res_w = _resolution_w;
	global.res_h = _resolution_h;
	global.window_mode = _window_mode;
	
	var _len = array_length(view_camera);
	for (var i = 0; i < _len; ++i){
		camera_destroy(view_camera[i]);
	}
	
	application_surface_draw_enable(false);
	
	__obj_stanncam_manager.display_res_w = _resolution_w;
	__obj_stanncam_manager.display_res_h = _resolution_h;
	stanncam_set_window_mode(_window_mode);
	
	__obj_stanncam_manager.resize_width = window_get_width();
	__obj_stanncam_manager.resize_height = window_get_height();
}

/// @function stanncam_set_resolution
/// @description updates the camera resolution, has no visible effect when fullscreened
/// @param {Real} _resolution_w
/// @param {Real} _resolution_h
function stanncam_set_resolution(_resolution_w, _resolution_h){
	__obj_stanncam_manager.display_res_w = _resolution_w;
	__obj_stanncam_manager.display_res_h = _resolution_h;
	window_set_size(_resolution_w, _resolution_h);
	__stanncam_update_resolution();
}

/// @function stanncam_get_preset_resolution_range
/// @description returns an array of preset resolutions using a starting index and an end index
/// @param STANNCAM_RES
function stanncam_get_preset_resolution(stanncam_res){
	return global.stanncam_res_presets[@stanncam_res];
}

/// @function stanncam_get_preset_resolution_range
/// @description returns an array of preset resolutions using a starting index and an end index
function stanncam_get_preset_resolution_range(start_i = 0,end_i = array_length(global.stanncam_res_presets)-1){
	var res_array = [];
	for (var i = start_i; i <= end_i; i++) {
	    array_push(res_array,global.stanncam_res_presets[@i]);
	}
	return res_array;
}

/// @function stanncam_set_window_mode(_window_mode)
/// @param {Real} _window_mode
/// @description set game to be windowed/fullscreen/borderless
function stanncam_set_window_mode(_window_mode){
	global.window_mode = _window_mode;
	switch (_window_mode) {
		case STANNCAM_WINDOW_MODE.WINDOWED:
			window_set_fullscreen(false);
			window_set_showborder(true);
			
			window_set_size(__obj_stanncam_manager.display_res_w, __obj_stanncam_manager.display_res_h);
			__stanncam_center(20, 20);
			
			break;
		case STANNCAM_WINDOW_MODE.FULLSCREEN:
			window_set_fullscreen(true);
			window_set_showborder(false);
			break;
		case STANNCAM_WINDOW_MODE.BORDERLESS:
			window_set_fullscreen(false);
			window_set_showborder(false);
			break;
	}
	call_later(10, time_source_units_frames, function(){
		__stanncam_update_resolution();
	});
}

/// @function stanncam_set_windowed()
/// @description set windowed
function stanncam_set_windowed(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.WINDOWED);
}

/// @function stanncam_set_fullscreen()
/// @description set fullscreen
function stanncam_set_fullscreen(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.FULLSCREEN);
}

/// @function stanncam_set_borderless()
/// @description set borderless
function stanncam_set_borderless(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.BORDERLESS);
}

/// @function stanncam_set_keep_aspect_ratio
/// @description set display keep_aspect_ratio
/// @param {Bool} _on_off
function stanncam_set_keep_aspect_ratio(_on_off){
	__obj_stanncam_manager.keep_aspect_ratio = _on_off;
	__stanncam_update_resolution();
}

/// @function stanncam_get_keep_aspect_ratio
/// @description get whether the display is keep_aspect_ratio
/// @returns {Bool}
function stanncam_get_keep_aspect_ratio(){
	return __obj_stanncam_manager.keep_aspect_ratio;
}

/// @function stanncam_fullscreen_ratio_compensate_x
/// @description if fullscreen keep_aspect_ratio is on it offsets the x value so the render is in the middle
/// @returns {Real}
function stanncam_fullscreen_ratio_compensate_x(){
	if(stanncam_get_keep_aspect_ratio()){
		return (window_get_width() - (global.game_w * __obj_stanncam_manager.__display_scale_x)) * 0.5;
	}
	return 0;
}

/// @function stanncam_fullscreen_ratio_compensate_y
/// @description if fullscreen keep_aspect_ratio is on it offsets the y value so the render is in the middle
/// @returns {Real}
function stanncam_fullscreen_ratio_compensate_y(){
	if(stanncam_get_keep_aspect_ratio()){
		return (window_get_height() - (global.game_h * __obj_stanncam_manager.__display_scale_y)) * 0.5;
	}
	return 0;
}

/// @function stanncam_set_gui_resolution
/// @description set the gui resolution
/// @param {Real} _gui_w
/// @param {Real} _gui_h
function stanncam_set_gui_resolution(_gui_w, _gui_h){
	global.gui_w = _gui_w;
	global.gui_h = _gui_h;
	__stanncam_update_resolution();
}

/// @function stanncam_get_gui_scale_x
/// @description gets how much bigger gui is from game
/// @returns {Real}
function stanncam_get_gui_scale_x(){
	return global.gui_w / global.game_w;
}

/// @function stanncam_get_gui_scale_y
/// @description gets how much bigger gui is from game
/// @returns {Real}
function stanncam_get_gui_scale_y(){
	return global.gui_h / global.game_h;
}

/// @function stanncam_get_res_scale_x
/// @description gets how much bigger res is from game
/// @returns {Real}
function stanncam_get_res_scale_x(){
	return global.res_w / global.game_w;
}

/// @function stanncam_get_res_scale_y
/// @description gets how much bigger res is from game
/// @returns {Real}
function stanncam_get_res_scale_y(){
	return global.res_h / global.game_h;
}

/// @function __stanncam_update_resolution
/// @description updates the camera resolution
/// @ignore
function __stanncam_update_resolution(){
	switch (global.window_mode) {
		//fullscreen
		case STANNCAM_WINDOW_MODE.FULLSCREEN:
			if(__obj_stanncam_manager.keep_aspect_ratio){
				var _ratio = global.game_w / global.game_h;
				global.res_w = display_get_height() * _ratio;
				global.res_h = display_get_height();
			} else {
				global.res_w = display_get_width();
				global.res_h = display_get_height();
			}
			window_set_size(display_get_width(), display_get_height());
			__stanncam_center();
			break;
		//borderless windowed
		case STANNCAM_WINDOW_MODE.BORDERLESS:
			if(__obj_stanncam_manager.keep_aspect_ratio){
				var _ratio = global.game_w / global.game_h;
				global.res_w = display_get_height() * _ratio;
				global.res_h = display_get_height();
			} else {
				global.res_w = display_get_width();
				global.res_h = display_get_height();
			}
		
			window_set_size(display_get_width(), display_get_height());
			__stanncam_center();
			break;
		//windowed
		case STANNCAM_WINDOW_MODE.WINDOWED:
			if(__obj_stanncam_manager.keep_aspect_ratio){
				var _res_ratio = (__obj_stanncam_manager.display_res_w / __obj_stanncam_manager.display_res_h) / (global.game_w / global.game_h);
				var _game_ratio = global.game_w / global.game_h;
				if(_res_ratio >= 1){
					global.res_w = __obj_stanncam_manager.display_res_h * _game_ratio;
					global.res_h = __obj_stanncam_manager.display_res_h;
				} else {
					global.res_w = __obj_stanncam_manager.display_res_w;
					global.res_h = __obj_stanncam_manager.display_res_w / _game_ratio;
				}
			} else {
				global.res_w = __obj_stanncam_manager.display_res_w;
				global.res_h = __obj_stanncam_manager.display_res_h;
			}
			break;
	}
	
	with(__obj_stanncam_manager){
		if(stanncam_get_keep_aspect_ratio()){
			var _ratio = (global.res_w / global.res_h) / (global.game_w / global.game_h);
			if(_ratio > 1){
				__display_scale_x = global.res_h / global.game_h;
				__display_scale_y = __display_scale_x;
				var _gui_x_scale = global.res_h / global.gui_h;
				var _gui_y_scale = _gui_x_scale;
			} else {
				__display_scale_x = global.res_w / global.game_w;
				__display_scale_y = __display_scale_x;
				var _gui_x_scale = global.res_w / global.gui_w;
				var _gui_y_scale = _gui_x_scale;
			}
		} else {
			__display_scale_x = global.res_w / global.game_w;
			__display_scale_y = global.res_h / global.game_h;
			var _gui_x_scale = global.res_w / global.gui_w;
			var _gui_y_scale = global.res_h / global.gui_h;
		}
		display_set_gui_maximize(_gui_x_scale, _gui_y_scale, stanncam_fullscreen_ratio_compensate_x(), stanncam_fullscreen_ratio_compensate_y());
	}
}

/// @function __stanncam_center
/// @description moves the window to the center of whichever window it's within
/// @param {Real} [_x=0] x offset
/// @param {Real} [_y=0] y offset
/// @ignore
function __stanncam_center(_x=0, _y=0){
	var _wx = window_get_x();
	var _wy = window_get_y();
	var _ww = window_get_width();
	var _wh = window_get_height();
	var _display_data = window_get_visible_rects(_wx, _wy, _wx + _ww, _wy + _wh);
	var _display_num = array_length(_display_data) / 8;
	
	//deletes all the overlay data as it's not needed
	for (var i = 0; i < _display_num; ++i){
		array_delete(_display_data, i * 4, 4);
	}
	
	var _middle_x = _wx + (_ww * 0.5);
	var _middle_y = _wy + (_wh * 0.5);
	
	var _outside_view = true;
	//checks which monitor the window is within
	for (var i = 0; i < _display_num; ++i){
		var _x1 = _display_data[(i * 4) + 0];
		var _y1 = _display_data[(i * 4) + 1];
		var _x2 = _display_data[(i * 4) + 2];
		var _y2 = _display_data[(i * 4) + 3];
		
		if(_middle_x > _x1 && _middle_x < _x2 && _middle_y > _y1 && _middle_y < _y2){
			window_set_position(_x1 + _x, _y1 + _y);
			_outside_view = false;
			break;
		}
	}
	//in case it somehow appears outside any of the monitors views it will go back to the first monitor
	if(_outside_view){
		window_set_position(_x, _y);
	}
}
