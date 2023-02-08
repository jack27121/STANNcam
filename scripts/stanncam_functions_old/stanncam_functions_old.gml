//spawns the camera into the first room, you can remove this line if you don't want that
//gml_pragma("global", "stanncam_init()");

/// @description spawns stanncam into the first room
function stanncam_init(){
	room_instance_add(room_first,0,0,obj_stanncam);
}

/// @function stanncam_toggle_fullscreen
/// @description toggle fullscreen on off
function stanncam_toggle_fullscreen(){
	window_set_fullscreen(!window_get_fullscreen());
	stanncam_update_resolution();
}

/// @function stanncam_update_resolution();
/// @description updates the camera resolution, change view_w view_h and upscale to see changes
function stanncam_update_resolution(){
	camera_set_view_size(cam,global.view_w*obj_stanncam.zoom,global.view_h*obj_stanncam.zoom);
	window_set_size(global.view_w*global.upscale, global.view_h*global.upscale);
	
	display_set_gui_size(global.gui_w,global.gui_h);
	
	surface_resize(application_surface, global.view_w,global.view_h);
	display_reset(0, false);
	
	view_wport[0] = global.view_w;
	view_hport[0] = global.view_h;
	
	with(obj_stanncam){		
		//var ratio = display_width / display_height;
		
		if(window_get_fullscreen())	{			
			display_width  = display_get_width();
			display_height = display_get_height();
		} else {
			display_width =  global.view_w * global.upscale;
			display_height = global.view_h* global.upscale;
		}
	}
}

/// @function stanncam_shake(magnitude, duration);
/// @description makes the screen shake
/// @param	magnitude
/// @param	duration in frames
function stanncam_shake(magnitude, duration) {
	obj_stanncam.shake_magnitude =+ magnitude;
	obj_stanncam.shake_length =+ duration;
	obj_stanncam.shake_time = 0;
}

/// @function stanncam_move(_x,_y,duration)
/// @description moves the camera to x y
/// @param _x
/// @param _y
/// @param _duration
function stanncam_move(_x, _y, duration){
	if(duration == 0){
		obj_stanncam.x = _x;
		obj_stanncam.y = _y;
	}else{
		with (obj_stanncam){
			moving = true;
			t = 0;
			xStart = x;
			yStart = y;
		}
		obj_stanncam.xTo = _x;
		obj_stanncam.yTo = _y;
		obj_stanncam.duration = duration;
	}
}

/// @function stanncam_zoom(_zoom,zoom_duration)
/// @description zooms the camera
/// @param _zoom
/// @param duration
function stanncam_zoom(_zoom, duration){
	if(duration == 0){
		obj_stanncam.zoom = _zoom;
		camera_set_view_size(cam,global.view_w*_zoom,global.view_h*_zoom);
		
	} else with (obj_stanncam){
		zooming = true;
		t_zoom = 0;
		zoomStart = zoom;
	}
	obj_stanncam.zoomTo = _zoom;
	obj_stanncam.zoom_duration = duration;
}

/// @function stanncam_speed(spd,threshold)
/// @description changes the speed of the camera
/// @param spd how fast the camera can move
/// @param threshold minimum distance for the speed to have full effect
function stanncam_speed(spd,threshold){
	obj_stanncam.spd = spd;	
	obj_stanncam.spd_threshold = threshold;
}

/// @function stanncam_x()
/// @description get camera x position. if need the middle of the screen use obj_stanncam.x
function stanncam_x(){
	return camera_get_view_x(cam);
}

/// @function stanncam_y()
/// @description get camera y position. if need the middle of the screen use obj_stanncam.y
function stanncam_y(){
	return camera_get_view_y(cam);
}

/// @function stanncam_out_of_bounds()
/// @param x_ position the object is temporarily moved to
/// @param y_ position the object is temporarily moved to
/// @param margin the margin for the camera bounds
/// @param ignore_zoom check bounds depending on zoom level
/// @description returns if the object is outside cam bounds
function stanncam_out_of_bounds(x_,y_,margin = 0, ignore_zoom = false){
	var x_delta = x;
	var y_delta = y;
	
	x = x_;
	y = y_;
	
	if(!ignore_zoom){
		
	}
	
	var col = ( //uses bounding box to see if it's within the camera view
		bbox_left   < stanncam_x() + margin ||
		bbox_top    < stanncam_y() + margin ||
		bbox_right  > (stanncam_x() + (global.view_w * obj_stanncam.zoom)) - margin ||
		bbox_bottom > (stanncam_y() + (global.view_h * obj_stanncam.zoom)) - margin
	)
	
	x = x_delta;
	y = y_delta;
	
	if(col)return true
	else return false;	
}

/// @func stanncam_point_in_rectangle(pos_x,pos_y,x1,y1,x2,y2)
/// @description checks if point is within rectangle relative to camera, default is full view
/// @param	pos_x
/// @param	pos_y
/// @param	x1
/// @param	y1
/// @param	x2
/// @param	y2
function stanncam_point_in_rectangle(pos_x,pos_y,x1=0,y1=0,x2=global.view_w,y2=global.view_h) {
	var stanncam_x = stanncam_x();
	var stanncam_y = stanncam_y();
	return point_in_rectangle(pos_x,pos_y,stanncam_x+x1,stanncam_y+y1,stanncam_x+x2,stanncam_y+y2);
}

/// @func stanncam_room_to_gui_x(x_)
/// @description returns the room x position as the position on the gui
/// @param	x_
function stanncam_room_to_gui_x(x_){
	x_ = x_ - stanncam_x();
	x_ = x_*(1+((global.gui_w-global.view_w)/global.view_w));
	
	return x_/obj_stanncam.zoom;
}

/// @func stanncam_room_to_gui_y(y_)
/// @description returns the room y position as the position on the gui
/// @param	y_
function stanncam_room_to_gui_y(y_){
	y_ = y_ - stanncam_y();
	y_ = y_*(1+((global.gui_h-global.view_h)/global.view_h));
	return y_/obj_stanncam.zoom;
}
