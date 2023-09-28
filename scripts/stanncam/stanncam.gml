/// @constructor stanncam
/// @description creates a new stanncam
/// @param {Real} [x_=0] - X position
/// @param {Real} [y_=0] - Y position
/// @param {Real} [width_=global.game_w]
/// @param {Real} [height_=global.game_h]
/// @param {Bool} [surface_extra_on_=false] - use surface_extra in regular draw events
/// @param {Bool} [smooth_draw_=true] - use fractional camera position when drawing
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
	
	//offset the camera from whatever it's looking at
	offset_x = 0;
	offset_y = 0;
	
	follow = undefined;
	
	//The extra surface is only neccesary if you are drawing the camera recursively in the room
	//Like a tv screen, where it can capture itself
	surface_extra_on = surface_extra_on_;
	
	spd = 10; //how fast the camera follows an instance
	spd_threshold = 50; //the minimum distance the camera is away, for the speed to be in full effect
	
	room_constrain = false; //if camera should be constrained to the room size
	
	//the camera bounding box, for the followed instance to leave before the camera starts moving
	bounds_w = 20;
	bounds_h = 20;
	bounds_dist_w = 0;
	bounds_dist_h = 0;
	
	//wether to use the fractional camera position when drawing the camera contents. Else it will be snapped to nearest integer
	smooth_draw = smooth_draw_;
	x_frac = 0;
	y_frac = 0;
	
	//which animation curve to use for moving/zooming the camera
	anim_curve = stanncam_ac_ease;
	anim_curve_zoom = stanncam_ac_ease;
	anim_curve_size = stanncam_ac_ease;
	anim_curve_offset = stanncam_ac_ease;
	
	surface = -1;
	surface_extra = -1;
	
	debug_draw = false;
	
	__destroyed = false;

	#region animation variables
	
	//moving
	__moving = false;
	__xStart = x;
	__yStart = y;
	__xTo = x;
	__yTo = y;
	__duration = 0;
	__t = 0;
	
	//width & height
	__size_change = false;
	__wStart = width;
	__hStart = height;
	__wTo = width;
	__hTo = height;
	__dimen_duration = 0;
	__dimen_t = 0;
	
	//offset
	__offset = false;
	__offset_xStart = 0;
	__offset_yStart = 0;
	__offset_xTo = 0;
	__offset_yTo = 0;
	__offset_duration = 0;
	__offset_t = 0;
	
	//zoom
	zoom_amount = 1;
	
	__zooming = false;
	zoom_x = 0;
	zoom_y = 0;
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
	
	__check_surface();
	__check_viewports();
	set_size(width,height);
	
	#endregion
	
#endregion

#region Step
	
	/// @function __step
	/// @description gets called every step
	/// @ignore
	static __step = function(){
		#region moving
		if (instance_exists(follow)){
	
			//update destination
			__xTo = follow.x;
			__yTo = follow.y;
			
			var x_dist = (__xTo - x);
			var y_dist = (__yTo - y);
			
			bounds_dist_w = (max(bounds_w,abs(x_dist)) - bounds_w) * sign(x_dist);
			bounds_dist_h = (max(bounds_h,abs(y_dist)) - bounds_h) * sign(y_dist);
			
			//update camera position
			if (abs(__xTo - x) > bounds_w){
				var _spd = (bounds_dist_w/spd_threshold)*spd;
				x+=_spd;
			}
			
			if (abs(y - __yTo) > bounds_h){
				var _spd = (bounds_dist_h/spd_threshold)*spd;
				y+=_spd;
			}
		
		} else if(__moving){
			//gradually moves camera into position based on duration
			x = stanncam_animcurve(__t,__xStart,__xTo,__duration,anim_curve);
			y = stanncam_animcurve(__t,__yStart,__yTo,__duration,anim_curve);
		
			__t++;
			if(x == __xTo && y == __yTo) __moving = false;
		}
		#endregion
		
		#region offset
		if(__offset){
			//gradually offsets camera based on duration
			offset_x = stanncam_animcurve(__offset_t,__offset_xStart,__offset_xTo,__offset_duration,anim_curve_offset);
			offset_y = stanncam_animcurve(__offset_t,__offset_yStart,__offset_yTo,__offset_duration,anim_curve_offset);
		
			__offset_t++;
			if(x == __offset_xTo && y == __offset_yTo) __offset = false;
		}
		#endregion
		
		#region screen-shake
		var stanncam_shake_x = stanncam_shake(__shake_time,__shake_magnitude,__shake_length);
		var stanncam_shake_y = stanncam_shake(__shake_time,__shake_magnitude,__shake_length);
		__shake_x = stanncam_shake_x;
		__shake_y = stanncam_shake_y;
		__shake_time++;
		#endregion
		
		#region zooming
			if(__zooming || __size_change){
				if(__size_change){
					//gradually resizes camera
					width =  stanncam_animcurve(__dimen_t,__wStart,__wTo,__dimen_duration,anim_curve_size);
					height = stanncam_animcurve(__dimen_t,__hStart,__hTo,__dimen_duration,anim_curve_size);
					
					__dimen_t++;
					
					if(width == __wTo && height == __hTo) __size_change = false;
				}
				
				if(__zooming){
					//gradually zooms camera
					zoom_amount = stanncam_animcurve(__t_zoom,__zoomStart,__zoomTo,__zoom_duration,anim_curve_zoom);
					__t_zoom++;
					
					if(zoom_amount == __zoomTo) __zooming = false;
				}
				zoom_x = ((width *zoom_amount) - width)/2;
				zoom_y = ((height*zoom_amount) - height)/2;
			}
		#endregion
		
		__update_view_size();
		
		__update_view_pos();
	}
#endregion
	
#region Dynamic functions
	
	/// @function clone
	/// @description returns a clone of the stanncam
	/// @returns {Struct.stanncam}
	/// @ignore
	static clone = function(){
		var clone = new stanncam(x,y,width,height);
		clone.surface_extra_on = surface_extra_on;
		clone.offset_x		 =   offset_x;
		clone.offset_y		 =   offset_y;
		clone.spd            =   spd;
		clone.spd_threshold  =   spd_threshold;
		clone.room_constrain =   room_constrain;
		clone.bounds_w       =   bounds_w;
		clone.bounds_h       =   bounds_h;
		clone.follow         =   follow;
		clone.smooth_draw    =   smooth_draw;
		clone.anim_curve	 =	 anim_curve;
		clone.anim_curve_zoom =	 anim_curve_zoom;
		clone.anim_curve_offset =anim_curve_offset;
		clone.anim_curve_size  = anim_curve_size;
		
		return clone;
	}
	
	/// @function move
	/// @description moves the camera to a position over a duration
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_duration=0]
	/// @ignore
	static move = function(_x, _y, _duration = 0){
		if(_duration == 0){ //if duration is 0 the view is updated immedietly
			x = _x;
			y = _y;
			__update_view_pos();
		} else {
			__moving = true;
			__t = 0;
			__xStart = x;
			__yStart = y;
			
			__xTo = _x;
			__yTo = _y;
			__duration = _duration;
		}
	}
	
	/// @function set_size
	/// @description sets the camera dimensions
	/// @param {Real} _width
	/// @param {Real} _height
	/// @param {Real} _duration
	/// @ignore
	static set_size = function(_width,_height, _duration = 0){
		if(_duration == 0){ //if duration is 0 the view is updated immedietly
			width = _width;
			height = _height;
			zoom_x = ((width *zoom_amount) - width)/2;
			zoom_y = ((height*zoom_amount) - height)/2;
			__update_view_size();
		} else {
			__size_change = true;
			__dimen_t = 0;
			__wStart = width;
			__hStart = height;
			
			__wTo = _width;
			__hTo = _height;
			__dimen_duration = _duration;
		}
	}
	
	/// @function offset
	/// @description offsets the camera over a duration
	/// @param {Real} _offset_x
	/// @param {Real} _offset_y
	/// @param {Real} [_duration=0]
	/// @ignore
	static offset = function(_offset_x, _offset_y, _duration = 0){
		if(_duration == 0){ //if duration is 0 the view is updated immedietly
			offset_x = _offset_x;
			offset_y = _offset_y;
			__update_view_pos();
		} else {
			__offset = true;
			__offset_t = 0;
			__offset_xStart = offset_x;
			__offset_yStart = offset_y;
			
			__offset_xTo = _offset_x;
			__offset_yTo = _offset_y;
			__offset_duration = _duration;
		}
	}
	
	/// @function zoom
	/// @description zooms the camera over a duration
	/// @param {Real} _zoom
	/// @param {Real} _duration
	/// @ignore
	static zoom = function(_zoom, _duration = 0){
		if(_duration == 0){ //if duration is 0 the view is updated immedietly
			zoom_amount = _zoom;
			zoom_x = ((width *zoom_amount) - width)/2;
			zoom_y = ((height*zoom_amount) - height)/2;
			__update_view_size();
		} else {
			__zooming = true;
			__t_zoom = 0;
			__zoomStart = zoom_amount;
			__zoomTo = _zoom;
			__zoom_duration = _duration;
		}
	}
	
	/// @function get_zoom_x
	/// @description there's a difference in how zoom works with smooth_draw on/off if you need to use the zoom_amount while smooth_draw is off, you need to use this function
	/// @ignore
	static get_zoom_x = function(){
		if (smooth_draw) return zoom_amount
		else return surface_get_width(surface) / width;
	}
	
	/// @function get_zoom_y
	/// @description there's a difference in how zoom works with smooth_draw on/off if you need to use the zoom_amount while smooth_draw is off, you need to use this function
	/// @ignore
	static get_zoom_y = function(){
		if (smooth_draw) return zoom_amount
		else return surface_get_height(surface) / height;
	}
	
	/// @function shake_screen
	/// @description makes the camera shake
	/// @param {Real} magnitude
	/// @param {Real} duration - duration in frames
	/// @ignore
	static shake_screen = function(magnitude, duration) {
		__shake_magnitude =+ magnitude;
		__shake_length =+ duration;
		__shake_time = 0;
	}
	
	/// @function set_speed
	/// @description changes the speed of the camera
	/// @param {Real} _spd - how fast the camera can move
	/// @param {Real} threshold - minimum distance for the speed to have full effect
	/// @ignore
	static set_speed = function(_spd,threshold){
		spd = _spd;
		spd_threshold = threshold;
	}
	
	/// @function get_x
	/// @description get camera corner x position. if need the middle of the camera use x
	/// @returns {Real}
	/// @ignore
	static get_x = function(){
		return camera_get_view_x(view_camera[cam_id]);
	}
	
	/// @function get_y
	/// @description get camera corner y position. if need the middle of the camera use y
	/// @returns {Real}
	/// @ignore
	static get_y = function(){
		return camera_get_view_y(view_camera[cam_id]);
	}
	
	/// @function get_mouse_x
	/// @description gets the mouse x position within room relative to the camera
	/// @returns {Real}
	/// @ignore
	static get_mouse_x = function(){
		var mouse_x_ = (((display_mouse_get_x() - window_get_x() - stanncam_fullscreen_ratio_compensate_x()) / (__obj_stanncam_manager.__display_scale_x * width)) * width * get_zoom_x()) + get_x();
		if(smooth_draw) return mouse_x_;
		else return mouse_x_ - (mouse_x_ mod get_zoom_x());
	}
	
	/// @function get_mouse_y
	/// @description gets the mouse y position within room relative to the camera
	/// @returns {Real}
	/// @ignore
	static get_mouse_y = function(){
		var mouse_y_ = (((display_mouse_get_y() - window_get_y() - stanncam_fullscreen_ratio_compensate_y()) / (__obj_stanncam_manager.__display_scale_y * height)) * height * get_zoom_y()) + get_y();
		if(smooth_draw) return mouse_y_;
		else return mouse_y_ - (mouse_y_ mod get_zoom_y());
	}
	
	/// @function room_to_gui_x
	/// @description returns the room x position as the position on the gui relative to camera
	/// @param {Real} x_
	/// @returns {Real}
	/// @ignore
	static room_to_gui_x = function(x_){
		return ((x_-get_x()-x_frac) / get_zoom_x()) * stanncam_get_gui_scale_x();
	}
	
	/// @function room_to_gui_y
	/// @description returns the room y position as the position on the gui relative to camera
	/// @param {Real} y_
	/// @returns {Real}
	/// @ignore
	static room_to_gui_y = function(y_){
		return ((y_-get_y()-y_frac) / get_zoom_y()) * stanncam_get_gui_scale_y();
	}
	
	/// @description returns the room x position as the position on the display relative to camera
	/// @param {Real} x_
	/// @returns {Real}
	// function room_to_display_x(x_){
	// 	return (x_-get_x())*stanncam_get_res_scale_x()/zoom_amount;
	// }
	
	/// @description returns the room y position as the position on the display relative to camera
	/// @param {Real} y_
	/// @returns {Real}
	//function room_to_display_y(y_){
	//	return (y_-get_y())*stanncam_get_res_scale_y()/zoom_amount;
	//}
	
	/// @function out_of_bounds
	/// @description returns if the position is outside camera bounds
	/// @param {Real} margin_ = 0
	/// @returns {Bool}
	/// @ignore
	static out_of_bounds = function(x_,y_,margin_ = 0){
		var col = ( //uses bounding box to see if it's within the camera view
			x_ <  get_x() + margin_ ||
			y_ <  get_y() + margin_ ||
			x_ > (get_x() + (width * zoom_amount)) - margin_ ||
			y_ > (get_y() + (height * zoom_amount)) - margin_
		);

		return col;
	}
	
	/// @function destroy
	/// @description marks the stanncam as destroyed
	/// @ignore
	static destroy = function(){
		follow = -1;
		array_set(global.stanncams,cam_id,-1);
		__obj_stanncam_manager.number_of_cams--;
		if(surface_exists(surface)) surface_free(surface);
		__destroyed = true;
	}
	
	/// @function is_destroyed
	/// @returns {Bool}
	/// @ignore
	static is_destroyed = function(){
		return __destroyed;
	}
#endregion
	
#region Internal functions
	
	/// @function __check_viewports
	/// @description enables viewports and sets viewports size
	/// @ignore
	static __check_viewports = function(){
		view_visible[cam_id] = true;
		__check_surface();
		__update_view_size(true);
	}
	
	/// @function __check_surface
	/// @description checks if surface & surface_extra exists and else creates it
	/// @ignore
	static __check_surface = function(width_ = width,height_ = height){
		if (!surface_exists(surface)){
			surface = surface_create(width,height);
		}
		
		if (surface_extra_on && !surface_exists(surface_extra)){
			surface_extra = surface_create(width,height);
		}
	}
	
	/// @function __predraw
	/// @description clears the surface
	/// @ignore
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
	
	/// @function __update_view_size
	/// @description updates the view size
	/// @ignore
	static __update_view_size = function(force = false){
		//if smooth_draw is off maintains pixel perfection even when zooming in and out
		//if on it is handled by the draw events
		if(smooth_draw){
			var ceiled_zoom = ceil(zoom_amount); //ensures the new surface size is a whole number
			var new_width  = width *ceiled_zoom;
			var new_height = height*ceiled_zoom;
		} else {
			var new_width  = floor(width *zoom_amount);
			var new_height = floor(height*zoom_amount);
			
			var width_2px = new_width mod 2;
			var height_2px= new_height mod 2;
			
			new_width  = new_width - width_2px ;
			new_height = new_height - height_2px;
		}
		//only runs if the size has changed (unless forced, used by __check_viewports to initialize)
		if(force || surface_get_width(surface) != new_width || surface_get_height(surface) != new_height){
			__check_surface();
			surface_resize(surface,					 new_width,new_height);
			camera_set_view_size(view_camera[cam_id],new_width,new_height);
		}
}

	/// @function __update_view_pos
	/// @description updates the view position
	/// @ignore
	static __update_view_pos = function(){
		//update camera view
		var new_x = x + offset_x - (width /  2) + __shake_x;
		var new_y = y + offset_y - (height / 2) + __shake_y;
		
		if(!smooth_draw){ // when smooth draw is off, the actual camera position gets rounded to whole numbers
			new_x = round(new_x);	
			new_y = round(new_y);
		}
		
		//Constrains camera to room
		if(room_constrain){
			constrain_offset_x = (clamp(new_x,0,room_width -width)  - new_x) * clamp(zoom_amount,0,1);
			constrain_offset_y = (clamp(new_y,0,room_height-height) - new_y) * clamp(zoom_amount,0,1);
			
			new_x += constrain_offset_x;
			new_y += constrain_offset_y;
		} else {
			constrain_offset_x = 0;
			constrain_offset_y = 0;
		}
		
		//apply zoom offset
		new_x -= zoom_x;
		new_y -= zoom_y;
		
		if(smooth_draw){
			//seperates position into whole and fractional parts
			x_frac = frac(new_x);
			y_frac = frac(new_y);
			
			new_x = floor(abs(new_x)) * sign(new_x);
			new_y = floor(abs(new_y)) * sign(new_y);
			
		} else {
			new_x = ceil(new_x);
			new_y = ceil(new_y);
		}
		
		camera_set_view_pos(view_camera[cam_id], new_x, new_y);
	}
#endregion

#region Drawing functions

	/// @function __debug_draw
	/// @description draws debug information
	/// @ignore
	static __debug_draw = function(){	
		if(debug_draw){		
			//draws camera bounding box
			if(follow != -1){
				surface_set_target(surface);
				
				var pre_color = draw_get_color();
				
				var x1 = (width /2) - bounds_w - offset_x - constrain_offset_x + zoom_x;
				var x2 = (width /2) + bounds_w - offset_x - constrain_offset_x + zoom_x;
				var y1 = (height/2) - bounds_h - offset_y - constrain_offset_y + zoom_y;
				var y2 = (height/2) + bounds_h - offset_y - constrain_offset_y + zoom_y;
				draw_set_color(c_white);
				draw_rectangle(x1,y1,x2,y2,true);
				
				
				draw_set_color(c_red);
				
				//top
				if(bounds_dist_h != 0){
					if(bounds_dist_h < 0) {
						draw_line(x1,y1,x2,y1);
					//bottom
					} else { 
						draw_line(x1,y2,x2,y2);
					}
				}
				
				//left
				if(bounds_dist_w != 0){
					if(bounds_dist_w < 0) {
						draw_line(x1,y1,x1,y2);
					//right
					} else { 
						draw_line(x2,y1,x2,y2);
					}
				}
				
				draw_set_color(pre_color);
				surface_reset_target();
			}
		}
	}
	
	/// @function draw
	/// @description draws stanncam
	/// @param {Real} x_
	/// @param {Real} y_
	/// @param {Real} [scale_x_=1]
	/// @param {Real} [scale_y_=1]
	/// @ignore
	static draw = function(x_,y_,scale_x_ = 1, scale_y_ = 1){
		__check_surface();
		__debug_draw();
		draw_surf(surface,x_,y_,scale_x_,scale_y_,0,0,width,height);
	}
	
	/// @function draw_part
	/// @description draws part of stanncam
	/// @param {Real} x_
	/// @param {Real} y_
	/// @param {Real} left_
	/// @param {Real} top_
	/// @param {Real} width_
	/// @param {Real} height_
	/// @param {Real} [scale_x_=1]
	/// @param {Real} [scale_y_=1]
	/// @ignore
	static draw_part = function(x_,y_,left_,top_,width_,height_,scale_x_ = 1, scale_y_ = 1){
		__check_surface();
		__debug_draw();
		draw_surf(surface,x_,y_,scale_x_,scale_y_,left_,top_,width_,height_);
	}
	
	/// @function draw_special
	/// @description pass in draw commands, and have them be scaled to match the stanncam
	/// @param {function} draw_func
	/// @param {Real} x_
	/// @param {Real} y_
	/// @param {Real} surf_width_
	/// @param {Real} surf_height_
	/// @param {Real} scale_x_
	/// @param {Real} scale_y_
	/// @ignore
	static draw_special = function(draw_func,x_,y_,surf_width_=width,surf_height_=height,scale_x_ = 1, scale_y_ = 1){

		var surface_special = surface_create(floor(surf_width_*zoom_amount),floor(surf_height_*zoom_amount));
		surface_set_target(surface_special);
		draw_clear_alpha(c_black,0);
		draw_func();
		surface_reset_target();
		draw_surf(surface_special,x_,y_,scale_x_,scale_y_,0,0,surf_width_,surf_height_);
		surface_free(surface_special);
	}
	
	/// @function draw_surf
	/// @description draws the supplied surface with the proper size and scaling
	/// @param {surface} surface_
	/// @param {Real} x_
	/// @param {Real} y_
	/// @param {Real} [scale_x_=1]
	/// @param {Real} [scale_y_=1]
	/// @param {Real} [left_=0]
	/// @param {Real} [top_=0]
	/// @param {Real} [width_=surface width]
	/// @param {Real} [height_=surface height]
	/// @ignore
	static draw_surf = function(surface_,x_,y_,scale_x_ = 1,scale_y_ = 1,left_ = 0, top_ = 0, width_ = surface_get_width(surface_),height_ = surface_get_height(surface_)){
		
		//offsets position to match with display resoultion
		x_ *= (global.res_w / global.game_w);
		y_ *= (global.res_h / global.game_h);
		
		x_ += stanncam_fullscreen_ratio_compensate_x();
		y_ += stanncam_fullscreen_ratio_compensate_y();
		
		if(smooth_draw){ 
		//draws super smooth both when moving and zooming	
			width_*= zoom_amount;
			height_*= zoom_amount;
			scale_x_/= zoom_amount;
			scale_y_/= zoom_amount;
			
			draw_surface_part_ext(surface_,x_frac+left_,y_frac+top_,width_,height_,x_,y_,__obj_stanncam_manager.__display_scale_x*scale_x_,__obj_stanncam_manager.__display_scale_y*scale_y_,-1,1);
		} else {
		//maintains pixel perfection when moving and zooming, appears more stuttery
			draw_surface_stretched(surface_,x_,y_, width_ * __obj_stanncam_manager.__display_scale_x*scale_x_, height_ * __obj_stanncam_manager.__display_scale_y*scale_y_);
		}
		
		
	}
#endregion

}