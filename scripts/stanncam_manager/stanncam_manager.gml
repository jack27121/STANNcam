enum STANNCAM_WINDOW_MODE{
	windowed,
	fullscreen,
	borderless	
}

/// @function stanncam_init
/// @description set game dimensions, display resolution, and gui dimensions, it's the same as game scale by default
/// @param {Real} game_w
/// @param {Real} game_h
/// @param {Real} [resolution_w=game_w]
/// @param {Real} [resolution_h=game_h]
/// @param {Real} [gui_w=game_w]
/// @param {Real} [gui_h=game_h]
/// @param {STANNCAM_WINDOW_MODE} [window_mode=windowed]
function stanncam_init(game_w,game_h,resolution_w=game_w,resolution_h=game_h,gui_w=game_w,gui_h=game_h,window_mode = STANNCAM_WINDOW_MODE.windowed){
	
	//if one already exists it is destroyed
	if(instance_exists(__obj_stanncam_manager)) instance_destroy(__obj_stanncam_manager);	
	
	instance_create_layer(0,0,"instances",__obj_stanncam_manager);
	global.stanncams = array_create(8,-1);
	global.game_w = game_w;
	global.game_h = game_h;
	global.gui_w = gui_w;
	global.gui_h = gui_h;
	global.res_w = resolution_w;
	global.res_h = resolution_h;
	global.window_mode = window_mode;
	
	for (var i = 0; i < array_length(view_camera); ++i) {
	    camera_destroy(view_camera[i]);
	}
	
	application_surface_draw_enable(false);
	
	__obj_stanncam_manager.display_res_w = resolution_w;
	__obj_stanncam_manager.display_res_h = resolution_h;
	stanncam_set_window_mode(window_mode);
	
	__obj_stanncam_manager.resize_width = window_get_width();
	__obj_stanncam_manager.resize_height = window_get_height();
}

/// @function stanncam_set_resolution
/// @description updates the camera resolution, has no visible effect when fullscreened
/// @param {Real} resolution_w
/// @param {Real} resolution_h
function stanncam_set_resolution(resolution_w,resolution_h){
	__obj_stanncam_manager.display_res_w = resolution_w;
	__obj_stanncam_manager.display_res_h = resolution_h;
	window_set_size(resolution_w, resolution_h);
	__stanncam_update_resolution();
}

/// @function stanncam_set_window_mode(window_mode)
/// @param  {STANNCAM_WINDOW_MODE} window_mode
/// @description set game to be windowed/fullscreen/borderless
function stanncam_set_window_mode(window_mode){
	global.window_mode = window_mode;
	switch (window_mode) {
	    case STANNCAM_WINDOW_MODE.windowed:
	        window_set_fullscreen(false);
			window_set_showborder(true);
			
			window_set_size(__obj_stanncam_manager.display_res_w, __obj_stanncam_manager.display_res_h);
			__stanncam_center(20,20);
			
	        break;
	    case STANNCAM_WINDOW_MODE.fullscreen:
	        window_set_fullscreen(true);
			window_set_showborder(false);			
	        break;
		case STANNCAM_WINDOW_MODE.borderless:
			window_set_fullscreen(false);
			window_set_showborder(false);
	        break;
	}		
	call_later(10,time_source_units_frames,function(){
		__stanncam_update_resolution();			
	});
}

/// @function stanncam_set_windowed()
/// @description set windowed
function stanncam_set_windowed(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.windowed);
}

/// @function stanncam_set_fullscreen()
/// @description set fullscreen
function stanncam_set_fullscreen(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.fullscreen);
}

/// @function stanncam_set_borderless()
/// @description set borderless
function stanncam_set_borderless(){
	stanncam_set_window_mode(STANNCAM_WINDOW_MODE.borderless);
}

/// @function stanncam_set_keep_aspect_ratio(on_off)
/// @param {boolean} on_off
/// @description set display keep_aspect_ratio
function stanncam_set_keep_aspect_ratio(on_off){
	__obj_stanncam_manager.keep_aspect_ratio = on_off;
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
		return (window_get_width() - (global.game_w*__obj_stanncam_manager.__display_scale_x))/2;
	} else return 0;
}

/// @function stanncam_fullscreen_ratio_compensate_y
/// @description if fullscreen keep_aspect_ratio is on it offsets the y value so the render is in the middle
/// @returns {Real}
function stanncam_fullscreen_ratio_compensate_y(){
	if(stanncam_get_keep_aspect_ratio()){
		return (window_get_height() - (global.game_h*__obj_stanncam_manager.__display_scale_y))/2;
	} else return 0;
}

/// @function stanncam_set_gui_resolution
/// @description set the gui resolution
/// @param {Real} gui_w
/// @param {Real} gui_h
function stanncam_set_gui_resolution(gui_w,gui_h){
	global.gui_w = gui_w;
	global.gui_h = gui_h;
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
		case STANNCAM_WINDOW_MODE.fullscreen:
			if(__obj_stanncam_manager.keep_aspect_ratio){
				var ratio = global.game_w / global.game_h;
				global.res_w = display_get_height() * ratio;
				global.res_h = display_get_height();
			} else {
				global.res_w = display_get_width();
				global.res_h = display_get_height();
			}
			window_set_size(display_get_width(), display_get_height());
			__stanncam_center();
	        break;
		//borderless windowed
		case STANNCAM_WINDOW_MODE.borderless:
			if(__obj_stanncam_manager.keep_aspect_ratio){
				var ratio = global.game_w / global.game_h;
				global.res_w = display_get_height() * ratio;
				global.res_h = display_get_height();
			} else {
				global.res_w = display_get_width();
				global.res_h = display_get_height();
			}
		
			window_set_size(display_get_width(), display_get_height());
			__stanncam_center();
	        break;
			
		//windowed
	    case STANNCAM_WINDOW_MODE.windowed:

			if(__obj_stanncam_manager.keep_aspect_ratio){
				var res_ratio = (__obj_stanncam_manager.display_res_w / __obj_stanncam_manager.display_res_h) / (global.game_w / global.game_h);
				var game_ratio = global.game_w / global.game_h;
				if(res_ratio > 1){
					global.res_w = __obj_stanncam_manager.display_res_h * game_ratio;
					global.res_h = __obj_stanncam_manager.display_res_h;
				} else {
					global.res_w = __obj_stanncam_manager.display_res_w;
					global.res_h = __obj_stanncam_manager.display_res_w * game_ratio;
				}
			} else {
				global.res_w = __obj_stanncam_manager.display_res_w;
				global.res_h = __obj_stanncam_manager.display_res_h;
			}
	        break;
	}
	
	with(__obj_stanncam_manager){
		if(stanncam_get_keep_aspect_ratio()){
			var ratio = (global.res_w / global.res_h) / (global.game_w / global.game_h);
			if(ratio > 1){
				__display_scale_x = global.res_h / global.game_h;
				__display_scale_y = __display_scale_x;
				var gui_x_scale = global.res_h / global.gui_h;
				var gui_y_scale = gui_x_scale;
			} else {
				__display_scale_x = global.res_w / global.game_w;
				__display_scale_y = __display_scale_x;
				var gui_x_scale = global.res_w / global.gui_w;
				var gui_y_scale = gui_x_scale;
			}
		} else {
			__display_scale_x = global.res_w / global.game_w;
			__display_scale_y = global.res_h / global.game_h;	
			var gui_x_scale = global.res_w / global.gui_w;
			var gui_y_scale = global.res_h / global.gui_h;
		}
		display_set_gui_maximize(gui_x_scale,gui_y_scale,stanncam_fullscreen_ratio_compensate_x(),stanncam_fullscreen_ratio_compensate_y());
	}
}

/// @function __stanncam_center
/// @description moves the window to the center of whichever window it's within
/// @param {int} x_ offset
/// @param {int} y_ offset
/// @ignore
function __stanncam_center(x_ = 0,y_ = 0){
	var wx = window_get_x();
	var wy = window_get_y();
	var ww = window_get_width();
	var wh = window_get_height();
	var display_data = window_get_visible_rects(wx, wy, wx + ww, wy + wh);
	var display_num = array_length(display_data) / 8;
	
	//deletes all the overlay data as it's not needed
	for (var i = 0; i < display_num; ++i) {
	    array_delete(display_data,i*4,4)
	}
	
	var middle_x = wx + (ww/2);
	var middle_y = wy + (wh/2);
	
	var outside_view = true;
	//checks which monitor the window is within
	for (var i = 0; i < display_num; ++i) {
		var x1 = display_data[(i*4)+0];
		var y1 = display_data[(i*4)+1];
		var x2 = display_data[(i*4)+2];
		var y2 = display_data[(i*4)+3];
		
	    if(middle_x > x1 && middle_x < x2 && middle_y > y1 && middle_y < y2){
			window_set_position(x1+x_,y1+y_);
			outside_view = false;
			break;
		}
	}
	//in case it somehow appears outside any of the monitors views it will go back to the first monitor
	if(outside_view){
		window_set_position(x_,y_);
	}	
}