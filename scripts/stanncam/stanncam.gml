/// @function stanncam()
/// @param x pos
/// @param y pos
/// @param width
/// @param height
/// @param surface_extra_on_ use surface_extra in regular draw events
/// @param smooth_draw_ use fractional camera position when drawing
/// @description creates a new stanncam
function stanncam(x_ = 0,y_ = 0,width_ = global.game_w,height_ = global.game_h, surface_extra_on_ = false, smooth_draw_ = true) constructor{
	#region init
	//whenever a new cam is created number_of_cams gets incremented
	cam_id = __obj_stanncam_manager.number_of_cams;
	
	//checks if there's already 8 cameras
	if(cam_id == 8){
		show_error("There can maximum be 8 cameras",true);
	}
	
	view_camera[cam_id] = camera_create();
	
	__obj_stanncam_manager.number_of_cams++;
	
	array_set(global.stanncams,cam_id,self);	
	#endregion
	
	#region variables
	x = x_;
	y = y_;
	
	width = width_;
	height = height_;
	
	surface_extra_on = surface_extra_on_;
	
	spd = 10; //how fast the camera follows an object
	spd_threshold = 50; //the minimum distance the camera is away, for the speed to be in full effect
	room_constrain = false; //if camera should be constrained to the room size
	
	//the camera bounding box, for the followed object to leave before the camera starts moving
	bounds_w = 20;
	bounds_h = 20;
	
	//wether to use the fractional camera position when drawing the camera contents. Else it will be snapped to nearest integer
	smooth_draw = smooth_draw_;
	__x_frac = 0;
	__y_frac = 0;
	
	
	surface = -1;

	surface_extra = -1;
	
	follow = -1;
	
	__destroyed = false;

	#region animation variables
	
	//moving
	__xStart = x;
	__yStart = y;
	__xTo = x;
	__yTo = y;
	__duration = 0;
	__t = 0;
	
	//zoom
	__zoom_amount = 1;
	__zoom_x = 0;
	__zoom_y = 0;
	__zooming = false;
	__t_zoom = 0;
	__zoomStart = 0;
	__zoomTo = 0;
	__zoom_duration = 0;
	
	//screen shake
	__shake_length = 0;
	__shake_magnitude = 0;
	__shake_time = 0;
	__shake_x = 0;
	__shake_y = 0;
	
	__moving = false;
	
	__check_surface();
	__check_viewports();
	__update_resolution();
	
	#endregion
	
	#endregion

	#region Step
	//gets called every step
	static __step = function(){
		if (instance_exists(follow)){
	
			//update destination
			__xTo = follow.x;
			__yTo = follow.y;
			
			var dist_w = max(bounds_w,abs(__xTo - x)) - bounds_w;
			var dist_h = max(bounds_h,abs(__yTo - y)) - bounds_h;
			
			//update camera position
			if (abs(__xTo - x) > bounds_w){
				var _spd = (dist_w/spd_threshold)*spd;
				if (x < __xTo) x+=_spd;
				else if (x > __xTo) x-=_spd;
			}
			
			if (abs(y - __yTo) > bounds_h){
				var _spd = (dist_h/spd_threshold)*spd;
				if (y < __yTo) y+=_spd;
				else if (y > __yTo) y-=_spd;
			}
		
		} else if(__moving){
			//gradually moves camera into position based on duration
			x = ease_in_out(__t,__xStart,__xTo-__xStart,__duration);
			y = ease_in_out(__t,__yStart,__yTo-__yStart,__duration);
		
			__t++;
			if(x == __xTo && y == __yTo) __moving = false;
		}
		
		#region screen-shake
		var stanncam_shake_x = shake(__shake_time++,__shake_magnitude,__shake_length);
		var stanncam_shake_y = shake(__shake_time++,__shake_magnitude,__shake_length);
		__shake_x = stanncam_shake_x;
		__shake_y = stanncam_shake_y;
		#endregion
		
		#region constrains camera to room bounds
		if(room_constrain){
			x = clamp(x,(width/2),room_width -(width/2));
			y = clamp(y,(height/2),room_height-(height/2));
		}
		#endregion
		
		#region zooming
		if(__zooming){
			//gradually zooms camera
			__zoom_amount = ease_in_out(__t_zoom,__zoomStart,__zoomTo-__zoomStart,__zoom_duration);
			__t_zoom++;
			if(__zoom_amount == __zoomTo) __zooming = false;
			camera_set_view_size(view_camera[cam_id],width*__zoom_amount,height*__zoom_amount);
			__zoom_x = ((width *__zoom_amount) - width)/2;
			__zoom_y = ((height*__zoom_amount) - height)/2;
		}
		#endregion
		
		//update camera view
		var new_x = x - ((width /  2) + __shake_x + __zoom_x);
		var new_y = y - ((height / 2) + __shake_y + __zoom_y);
		
		//seperates position into whole and fractional parts
		if(smooth_draw == true){
			__x_frac = frac(new_x);
			__y_frac = frac(new_y);
		} else {
			__x_frac = 0;
			__y_frac = 0;
		}
		
		new_x = floor(new_x);
		new_y = floor(new_y);
		
		camera_set_view_pos(view_camera[cam_id], new_x, new_y);
	}
	#endregion
	
	#region Drawing functions
	
	static draw = function(x_,y_,scale_x_ = 1, scale_y_ = 1){
		__check_surface();
		var x_scale = __obj_stanncam_manager.display_res_w / global.game_w
		var y_scale = __obj_stanncam_manager.display_res_h / global.game_h
		x_ *= x_scale;
		y_ *= y_scale;
		
		x_ += stanncam_fullscreen_ratio_compensate();
		
		var w_ = surface_get_width(surface);
		var h_ = surface_get_height(surface);
		
		draw_surface_part_ext(surface,__x_frac,__y_frac,w_,h_,x_,y_,__display_scale_x*scale_x_,__display_scale_y*scale_y_,-1,1);
	}
	#endregion
	
	#region Dynamic functions
	
	/// @description returns a clone of the camera
	static clone = function(){
		var clone = new stanncam(x,y,width,height);
		clone.spd            =   spd;
		clone.spd_threshold  =   spd_threshold;
		clone.room_constrain =   room_constrain;
		clone.bounds_w       =   bounds_w;
		clone.bounds_h       =   bounds_h;
		clone.follow         =   follow;
		
		return clone;
	}
	
	/// @description sets the camera size
	/// @param	width
	/// @param	height
	static set_size = function(_width,_height){
		width = _width;
		height = _height;
		surface_resize(surface,width,height);
		__update_resolution();
		camera_set_view_size(view_camera[cam_id],width*__zoom_amount,height*__zoom_amount);
	}
	
	/// @function shake_screen(magnitude, duration);
	/// @description makes the camera shake
	/// @param	magnitude
	/// @param	duration in frames
	static shake_screen = function(magnitude, duration) {
		__shake_magnitude =+ magnitude;
		__shake_length =+ duration;
		__shake_time = 0;
	}
	
	/// @function move(_x,_y,duration)
	/// @description moves the camera to x y
	/// @param _x
	/// @param _y
	/// @param _duration
	static move = function(_x, _y, _duration = 0){
		if(_duration == 0){
			x = _x;
			y = _y;
			
			var new_x = x - ((width /  2) + __shake_x + __zoom_x);
			var new_y = y - ((height / 2) + __shake_y + __zoom_y);
		
			camera_set_view_pos(view_camera[cam_id], new_x, new_y);
		}else{
			__moving = true;
			__t = 0;
			__xStart = x;
			__yStart = y;
			
			__xTo = _x;
			__yTo = _y;
			__duration = _duration;
		}
	}
	
	/// @function zoom(_zoom,zoom_duration)
	/// @description zooms the camera
	/// @param _zoom
	/// @param duration
	static zoom = function(_zoom, _duration){
		if(_duration == 0){
			__zoom_amount = _zoom;
			camera_set_view_size(view_camera[cam_id],width*_zoom,height*_zoom);
			__zoom_x = ((width *__zoom_amount) - width)/2;
			__zoom_y = ((height*__zoom_amount) - height)/2;
			
		} else {
			__zooming = true;
			__t_zoom = 0;
			__zoomStart = __zoom_amount;
		}
		__zoomTo = _zoom;
		__zoom_duration = _duration;
	}
	
	/// @function set_speed(spd,threshold)
	/// @description changes the speed of the camera
	/// @param spd how fast the camera can move
	/// @param threshold minimum distance for the speed to have full effect
	static set_speed = function(_spd,threshold){
		spd = _spd;
		spd_threshold = threshold;
	}
	
	/// @function get_x()
	/// @description get camera corner x position. if need the middle of the camera use x
	static get_x = function(){
		return camera_get_view_x(view_camera[cam_id]);
	}
	
	/// @function get_y()
	/// @description get camera corner y position. if need the middle of the camera use y
	static get_y = function(){
		return camera_get_view_y(view_camera[cam_id]);
	}
	
	/// @description gets the mouse x position within room relative to the camera
	static get_mouse_x = function(){
		return (((display_mouse_get_x() - window_get_x() - stanncam_fullscreen_ratio_compensate()) / (__display_scale_x * width)) * width) + get_x();
	}
	
	/// @description gets the mouse y position within room relative to the camera
	static get_mouse_y = function(){
		return (((display_mouse_get_y() - window_get_y()) / (__display_scale_y * height)) * height) + get_y();
	}
	
	/// @func room_to_gui_x(x_)
	/// @description returns the room x position as the position on the gui relative to camera
	/// @param	x_
	static room_to_gui_x = function(x_){	
		return (x_-get_x()-__x_frac)*stanncam_get_gui_scale_x()/__zoom_amount;
	}
	
	/// @func room_to_gui_y(y_)
	/// @description returns the room y position as the position on the gui relative to camera
	/// @param	y_
	static room_to_gui_y = function(y_){
		return (y_-get_y()-__y_frac)*stanncam_get_gui_scale_y()/__zoom_amount;
	}
	
	/// @func room_to_display_x(x_)
	/// @description returns the room x position as the position on the display relative to camera
	/// @param	x_
	//function room_to_display_x(x_){	
	//	return (x_-get_x())*stanncam_get_res_scale_x()/__zoom_amount;
	//}
	
	/// @func room_to_display_y(y_)
	/// @description returns the room y position as the position on the display relative to camera
	/// @param	y_
	//function room_to_display_y(y_){
	//	return (y_-get_y())*stanncam_get_res_scale_y()/__zoom_amount;
	//}
	
	/// @function out_of_bounds()
	/// @param x_ position
	/// @param y_ position
	/// @param margin the margin for the camera bounds
	/// @description returns if the position is outside cam bounds
	function out_of_bounds(x_,y_,margin = 0){

		var col = ( //uses bounding box to see if it's within the camera view
			x_ <  get_x() + margin ||
			y_ <  get_y() + margin ||
			x_ > (get_x() + (width * __zoom_amount)) - margin ||
			y_ > (get_y() + (height * __zoom_amount)) - margin
		)

		if(col)return true
		else return false;	
	}
	
	/// @function destroy()
	static destroy = function(){	
		follow = -1;
		array_set(global.stanncams,cam_id,-1);
		__obj_stanncam_manager.number_of_cams--;
		if(surface_exists(surface)) surface_free(surface);
		if(surface_exists(surface)) surface_free(surface);
		__destroyed = true;
	}
	
	/// @function is_destroyed()
	static is_destroyed = function(){
		return __destroyed;	
	}
	#endregion
	
	#region Internal functions	
	
	//enables viewports and sets viewports size
	static __check_viewports = function(){
		view_visible[cam_id] = true;
		set_size(width,height);
	}
	
	//checks if surface_extra exists and else creates it and attaches it
	static __check_surface = function(){
		if (!surface_exists(surface)){
			surface = surface_create(width,height);
		}
		
		if (surface_extra_on && !surface_exists(surface_extra)){
			surface_extra = surface_create(width,height);
		}
	}
	
	//updates cameras drawing resolution
	static __update_resolution = function(){		
		__display_scale_x = __obj_stanncam_manager.display_res_w / global.game_w;
		__display_scale_y = __obj_stanncam_manager.display_res_h / global.game_h;

		view_set_camera(cam_id, view_camera[cam_id]);
	}
	
	//clears the surface
	static __predraw = function(){
		__check_surface();
		if(surface_extra_on){
			surface_copy(surface_extra,0,0,surface);
		}
		surface_set_target(surface);
		draw_clear_alpha(c_black,0);
		surface_reset_target();
		view_set_surface_id(cam_id,surface);
	}
	#endregion
}