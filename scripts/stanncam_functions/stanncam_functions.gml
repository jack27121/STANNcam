//spawns the camera into the first room, you can remove this line if you don't want that
gml_pragma("global", "stanncam_init()");

/// @description spawns the camera object into the first room
function stanncam_init(){
	room_instance_add(room_first,0,0,obj_stanncam);
}

/// @function toggle_fullscreen
/// @description toggle fullscreen on off
function toggle_fullscreen(){
	window_set_fullscreen(!window_get_fullscreen());
	resolution_update();
}

/// @function resolution_update();
/// @description updates the camera resolution, change view_w view_h and upscale to see changes
function resolution_update(){
	camera_set_view_size(cam,global.view_w,global.view_h);
	window_set_size(global.view_w*global.upscale, global.view_h*global.upscale);
	
	display_set_gui_size(global.gui_w,global.gui_h);
	
	surface_resize(application_surface, global.view_w,global.view_h);
	display_reset(0, false);
	
	view_wport[0] = global.view_w;
	view_hport[0] = global.view_h;
	
	with(obj_stanncam){		
		//var ratio = display_width / display_height;
		
		if(window_get_fullscreen())	{
			//var gui_x_scale = 1+(display_get_width() - display_width)/display_width;
			//var gui_y_scale = 1+(display_get_height() - display_height)/display_height;
			
			//display_set_gui_maximize(gui_x_scale,gui_y_scale);
			
			display_width  = display_get_width();
			display_height = display_get_height();
		} else {
			display_width =  global.view_w * global.upscale;
			display_height = global.view_h* global.upscale;
		}
	}
}

/// @function screen_shake(magnitude, duration);
/// @description makes the screen shake
/// @param	magnitude
/// @param	duration in frames
function screen_shake(magnitude, duration) {
	obj_stanncam.shake_magnitude =+ magnitude;
	obj_stanncam.shake_length =+ duration;
	obj_stanncam.shake_time = 0;
}

/// @function camera_move(_x,_y,duration)
/// @description moves the camera to x y
/// @param _x
/// @param _y
/// @param _duration
function camera_move(_x, _y, duration){
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

/// @function camera_zoom(_zoom,zoom_duration)
/// @description zooms the camera
/// @param _zoom
/// @param duration
function camera_zoom(_zoom, duration){
	if(duration == 0){
		obj_stanncam.zoom = _zoom;
		camera_set_view_size(cam,view_w*_zoom,view_h*_zoom);
		
	} else with (obj_stanncam){
		zooming = true;
		t_zoom = 0;
		zoomStart = zoom;
	}
	obj_stanncam.zoomTo = _zoom;
	obj_stanncam.zoom_duration = duration;
}

/// @function cam_x()
/// @description get camera x position. if need the middle of the screen use obj_stanncam.x
function cam_x(){
	return camera_get_view_x(cam);
}

/// @function cam_y()
/// @description get camera y position. if need the middle of the screen use obj_stanncam.y
function cam_y(){
	return camera_get_view_y(cam);
}

/// @function out_cam_bounds()
/// @margin the margin for the camera bounds
/// @description returns if the object is outside cam bounds
function out_cam_bounds(margin = 64){
	var col = ( //uses boundinx box to see if it's within the camera view
		room_to_gui_x(bbox_left)   < margin ||
		room_to_gui_y(bbox_top)    < margin ||
		room_to_gui_x(bbox_right)  > display_get_gui_width() + margin ||
		room_to_gui_y(bbox_bottom) > display_get_gui_height() + margin
	)
	if(col) return true
	else return false;	
}

/// @func point_in_rectangle_camera(pos_x,pos_y,x1,y1,x2,y2)
/// @description checks if point is within rectangle relative to camera, default is full view
/// @param	pos_x
/// @param	pos_y
/// @param	x1
/// @param	y1
/// @param	x2
/// @param	y2
function point_in_rectangle_camera(pos_x,pos_y,x1=0,y1=0,x2=global.view_w,y2=global.view_h) {
	var cam_x = cam_x();
	var cam_y = cam_y();
	return point_in_rectangle(pos_x,pos_y,cam_x+x1,cam_y+y1,cam_x+x2,cam_y+y2);
}

/// @func room_to_gui_x(x_)
/// @description returns the room x position as the position on the gui
/// @param	x_
function room_to_gui_x(x_){
	x_ = x_ - cam_x();
	//if(obj_stanncam.gui_hires){
	//	x_ = x_*global.upscale;
	//}
	
	x_ = x_*(1+((global.gui_w-global.view_w)/global.view_w));
	
	return x_/obj_stanncam.zoom;
}

/// @func room_to_gui_y(y_)
/// @description returns the room y position as the position on the gui
/// @param	y_
function room_to_gui_y(y_){
	y_ = y_ - cam_y();
	//if(obj_stanncam.gui_hires){
	//	y_ = y_*global.upscale;
	//}
	y_ = y_*(1+((global.gui_h-global.view_h)/global.view_h));
	return y_/obj_stanncam.zoom;
}
