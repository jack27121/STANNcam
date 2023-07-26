/// @function stanncam_init
/// @description set game dimensions, display resolution, and gui dimensions, it's the same as game scale by default
/// @param {Real} game_w
/// @param {Real} game_h
/// @param {Real} [resolution_w=game_w]
/// @param {Real} [resolution_h=game_h]
/// @param {Real} [gui_w=game_w]
/// @param {Real} [gui_h=game_h]
function stanncam_init(game_w,game_h,resolution_w=game_w,resolution_h=game_h,gui_w=game_w,gui_h=game_h){
	
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
	
	for (var i = 0; i < array_length(view_camera); ++i) {
	    camera_destroy(view_camera[i]);
	}
	
	application_surface_draw_enable(false);
	
	stanncam_set_resolution(resolution_w,resolution_h);
}

/// @function stanncam_set_resolution
/// @description updates the camera resolution, has no visible effect when fullscreened
/// @param {Real} resolution_w
/// @param {Real} resolution_h
function stanncam_set_resolution(resolution_w,resolution_h){
	__obj_stanncam_manager.display_res_w = resolution_w;
	__obj_stanncam_manager.display_res_h = resolution_h;
	__stanncam_update_resolution();
}

/// @function stanncam_toggle_fullscreen
/// @description toggle fullscreen on/off
function stanncam_toggle_fullscreen(){
	window_set_fullscreen(!window_get_fullscreen());
	__stanncam_update_resolution();
}

/// @function stanncam_toggle_keep_aspect_ratio
/// @description toggle display keep_aspect_ratio
function stanncam_toggle_keep_aspect_ratio(){
	__obj_stanncam_manager.keep_aspect_ratio = !__obj_stanncam_manager.keep_aspect_ratio;
	__stanncam_update_resolution();
}

/// @function stanncam_get_keep_aspect_ratio
/// @description get whether the display is keep_aspect_ratio
/// @returns {Bool}
function stanncam_get_keep_aspect_ratio(){
	return __obj_stanncam_manager.keep_aspect_ratio;
}

/// @function stanncam_fullscreen_ratio_compensate
/// @description if fullscreen keep_aspect_ratio is on it offsets the x value so the render is in the middle
/// @returns {Real}
function stanncam_fullscreen_ratio_compensate(){
	if(stanncam_get_keep_aspect_ratio() && window_get_fullscreen()){
		return (display_get_width() - global.res_w)/2;
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
	if(window_get_fullscreen())	{
		if(__obj_stanncam_manager.keep_aspect_ratio){
			var ratio = global.game_w / global.game_h;
			
			global.res_w = display_get_height() * ratio;
			global.res_h = display_get_height();
		} else {
			
			global.res_w = display_get_width();
			global.res_h = display_get_height();
		}
	} else {
		if(__obj_stanncam_manager.keep_aspect_ratio){
			var ratio = global.game_w / global.game_h;
			
			global.res_w = __obj_stanncam_manager.display_res_h * ratio;
			global.res_h = __obj_stanncam_manager.display_res_h;
		} else {
			
			global.res_w = __obj_stanncam_manager.display_res_w;
			global.res_h = __obj_stanncam_manager.display_res_h;
		}
		
		window_set_size(global.res_w, global.res_h);
	}
	
	var gui_x_scale = global.res_w / global.gui_w;
	var gui_y_scale = global.res_h / global.gui_h;
	
	display_set_gui_maximize(gui_x_scale,gui_y_scale,stanncam_fullscreen_ratio_compensate());
	//surface_resize(application_surface, display_get_gui_width(), display_get_gui_height())
	
	for (var i = 0; i < array_length(global.stanncams); ++i) {
		if (global.stanncams[i] == -1) continue;
		global.stanncams[i].__update_resolution();
	}
}
