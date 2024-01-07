/// @constructor stanncam
/// @description creates a new stanncam
/// @param {Real} [_x=0] - X position
/// @param {Real} [_y=0] - Y position
/// @param {Real} [_width=global.game_w]
/// @param {Real} [_height=global.game_h]
/// @param {Bool} [_surface_extra_on=false] - use surface_extra in regular draw events
/// @param {Bool} [_smooth_draw=true] - use fractional camera position when drawing
function stanncam(_x=0, _y=0, _width=global.game_w, _height=global.game_h, _surface_extra_on=false, _smooth_draw=true) constructor{
#region init
	//whenever a new cam is created number_of_cams gets incremented
	cam_id = __obj_stanncam_manager.number_of_cams;
	
	//checks if there's already 8 cameras
	if(cam_id == 8){
		show_error("There can only be a maximum of 8 cameras.", true);
	}

	__camera = camera_create();
	view_camera[cam_id] = __camera;
	
	++__obj_stanncam_manager.number_of_cams;
	
	global.stanncams[cam_id] = self;
#endregion

#region variables
	x = _x;
	y = _y;
	
	width = _width;
	height = _height;
	
	//offset the camera from whatever it's looking at
	offset_x = 0;
	offset_y = 0;
	
	follow = undefined;
	
	//The extra surface is only neccesary if you are drawing the camera recursively in the room
	//Like a tv screen, where it can capture itself
	surface_extra_on = _surface_extra_on;
	
	//the first camera uses the application surface
	use_app_surface = cam_id == 0;
	
	spd = 10; //how fast the camera follows an instance
	spd_threshold = 50; //the minimum distance the camera is away, for the speed to be in full effect
	
	room_constrain = false; //if camera should be constrained to the room size
	
	//the camera bounding box, for the followed instance to leave before the camera starts moving
	bounds_w = 20;
	bounds_h = 20;
	bounds_dist_w = 0;
	bounds_dist_h = 0;
	
	//wether to use the fractional camera position when drawing the camera contents. Else it will be snapped to nearest integer
	smooth_draw = _smooth_draw;
	x_frac = 0;
	y_frac = 0;
	
	//which animation curve to use for moving/zooming the camera
	anim_curve = stanncam_ac_ease;
	anim_curve_zoom = stanncam_ac_ease;
	anim_curve_size = stanncam_ac_ease;
	anim_curve_offset = stanncam_ac_ease;
	
	surface = -1;
	surface_extra = -1;
	__surface_special = -1;
	
	debug_draw = false;
	
	__destroyed = false;
	
	//zone constrain
	__zone_constrain_amount = 0;
	__zone = noone;
	zone_constrain_speed = 0.1;

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
	set_size(width, height);
	
	#endregion
	
#endregion

#region Step
	
	/// @function __step
	/// @description gets called every step
	/// @ignore
	static __step = function(){
		#region moving
		if(instance_exists(follow)){
	
			//update destination
			__xTo = follow.x;
			__yTo = follow.y;			
			
			var _x_dist = __xTo - x;
			var _y_dist = __yTo - y;
			
			bounds_dist_w = (max(bounds_w, abs(_x_dist)) - bounds_w) * sign(_x_dist);
			bounds_dist_h = (max(bounds_h, abs(_y_dist)) - bounds_h) * sign(_y_dist);
			
			//update camera position
			if(abs(__xTo - x) > bounds_w){
				var _spd = (bounds_dist_w / spd_threshold) * spd;
				x += _spd;
			}
			
			if(abs(y - __yTo) > bounds_h){
				var _spd = (bounds_dist_h / spd_threshold) * spd;
				y += _spd;
			}
		
		} else if(__moving){
			//gradually moves camera into position based on duration
			x = stanncam_animcurve(__t, __xStart, __xTo, __duration, anim_curve);
			y = stanncam_animcurve(__t, __yStart, __yTo, __duration, anim_curve);
		
			__t++;
			
			if(x == __xTo && y == __yTo) __moving = false;
		}
		#endregion
		
		#region zone constrain
		var _constrain_on = false;
		if(follow != undefined){
			var __zone_new = instance_position(follow.x,follow.y,obj_stanncam_zone)
			if(__zone_new != noone){
				__zone = __zone_new;
				_constrain_on = true;
			}
		}
		if(_constrain_on){
			__zone_constrain_amount = lerp(__zone_constrain_amount,1,zone_constrain_speed);
		} else {
			__zone_constrain_amount = lerp(__zone_constrain_amount,0,zone_constrain_speed);
		}
		
		#endregion
		
		#region offset
		if(__offset){
			//gradually offsets camera based on duration
			offset_x = stanncam_animcurve(__offset_t, __offset_xStart, __offset_xTo, __offset_duration, anim_curve_offset);
			offset_y = stanncam_animcurve(__offset_t, __offset_yStart, __offset_yTo, __offset_duration, anim_curve_offset);
		
			__offset_t++;
			if(x == __offset_xTo && y == __offset_yTo) __offset = false;
		}
		#endregion
		
		#region screen-shake
		var _stanncam_shake_x = stanncam_shake(__shake_time, __shake_magnitude, __shake_length);
		var _stanncam_shake_y = stanncam_shake(__shake_time, __shake_magnitude, __shake_length);
		__shake_x = _stanncam_shake_x;
		__shake_y = _stanncam_shake_y;
		__shake_time++;
		#endregion
		
		#region zooming
			if(__zooming || __size_change){
				if(__size_change){
					//gradually resizes camera
					width = stanncam_animcurve(__dimen_t, __wStart, __wTo, __dimen_duration, anim_curve_size);
					height = stanncam_animcurve(__dimen_t, __hStart, __hTo, __dimen_duration, anim_curve_size);
					
					__dimen_t++;
					
					if(width == __wTo && height == __hTo) __size_change = false;
				}
				
				if(__zooming){
					//gradually zooms camera
					zoom_amount = stanncam_animcurve(__t_zoom, __zoomStart, __zoomTo, __zoom_duration, anim_curve_zoom);
					__t_zoom++;
					
					if(zoom_amount == __zoomTo) __zooming = false;
				}
				zoom_x = ((width * zoom_amount) - width) * 0.5;
				zoom_y = ((height * zoom_amount) - height) * 0.5;
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
		var _clone = new stanncam(x, y, width, height);
		_clone.surface_extra_on = surface_extra_on;
		_clone.offset_x = offset_x;
		_clone.offset_y = offset_y;
		_clone.spd = spd;
		_clone.spd_threshold = spd_threshold;
		_clone.room_constrain = room_constrain;
		_clone.bounds_w = bounds_w;
		_clone.bounds_h = bounds_h;
		_clone.follow = follow;
		_clone.smooth_draw = smooth_draw;
		_clone.anim_curve = anim_curve;
		_clone.anim_curve_zoom = anim_curve_zoom;
		_clone.anim_curve_offset = anim_curve_offset;
		_clone.anim_curve_size = anim_curve_size;
		
		return _clone;
	}
	
	/// @function move
	/// @description moves the camera to a position over a duration
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_duration=0]
	/// @ignore
	static move = function(_x, _y, _duration=0){
		if(_duration == 0){ //if duration is 0 the view is updated immediately
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
	/// @param {Real} [_duration=0]
	/// @ignore
	static set_size = function(_width, _height, _duration=0){
		if(_duration == 0){ //if duration is 0 the view is updated immediately
			width = _width;
			height = _height;
			zoom_x = ((width * zoom_amount) - width) * 0.5;
			zoom_y = ((height * zoom_amount) - height) * 0.5;
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
	static offset = function(_offset_x, _offset_y, _duration=0){
		if(_duration == 0){ //if duration is 0 the view is updated immediately
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
	/// @param {Real} [_duration=0]
	/// @ignore
	static zoom = function(_zoom, _duration=0){
		if(_duration == 0){ //if duration is 0 the view is updated immediately
			zoom_amount = _zoom;
			zoom_x = ((width * zoom_amount) - width) * 0.5;
			zoom_y = ((height * zoom_amount) - height) * 0.5;
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
		if(smooth_draw) return zoom_amount;
		return surface_get_width(surface) / width;
	}
	
	/// @function get_zoom_y
	/// @description there's a difference in how zoom works with smooth_draw on/off if you need to use the zoom_amount while smooth_draw is off, you need to use this function
	/// @ignore
	static get_zoom_y = function(){
		if(smooth_draw) return zoom_amount;
		return surface_get_height(surface) / height;
	}
	
	/// @function shake_screen
	/// @description makes the camera shake
	/// @param {Real} _magnitude
	/// @param {Real} _duration - duration in frames
	/// @ignore
	static shake_screen = function(_magnitude, _duration){
		__shake_magnitude = _magnitude;
		__shake_length = _duration;
		__shake_time = 0;
	}
	
	/// @function set_speed
	/// @description changes the speed of the camera
	/// @param {Real} _spd - how fast the camera can move
	/// @param {Real} _threshold - minimum distance for the speed to have full effect
	/// @ignore
	static set_speed = function(_spd, _threshold){
		spd = _spd;
		spd_threshold = _threshold;
	}
	
	/// @function get_x
	/// @description get camera corner x position. if need the middle of the camera use x
	/// @returns {Real}
	/// @ignore
	static get_x = function(){
		return camera_get_view_x(__camera);
	}
	
	/// @function get_y
	/// @description get camera corner y position. if need the middle of the camera use y
	/// @returns {Real}
	/// @ignore
	static get_y = function(){
		return camera_get_view_y(__camera);
	}
	
	/// @function get_mouse_x
	/// @description gets the mouse x position within room relative to the camera
	/// @returns {Real}
	/// @ignore
	static get_mouse_x = function(){
		var _mouse_x = (((display_mouse_get_x() - window_get_x() - stanncam_fullscreen_ratio_compensate_x()) / (__obj_stanncam_manager.__display_scale_x * width)) * width * get_zoom_x()) + get_x();
		if(smooth_draw) return _mouse_x;
		return _mouse_x - (_mouse_x mod get_zoom_x());
	}
	
	/// @function get_mouse_y
	/// @description gets the mouse y position within room relative to the camera
	/// @returns {Real}
	/// @ignore
	static get_mouse_y = function(){
		var _mouse_y = (((display_mouse_get_y() - window_get_y() - stanncam_fullscreen_ratio_compensate_y()) / (__obj_stanncam_manager.__display_scale_y * height)) * height * get_zoom_y()) + get_y();
		if(smooth_draw) return _mouse_y;
		return _mouse_y - (_mouse_y mod get_zoom_y());
	}
	
	/// @function room_to_gui_x
	/// @description returns the room x position as the position on the gui relative to camera
	/// @param {Real} _x
	/// @returns {Real}
	/// @ignore
	static room_to_gui_x = function(_x){
		return ((_x - get_x() - x_frac) / get_zoom_x()) * stanncam_get_gui_scale_x();
	}
	
	/// @function room_to_gui_y
	/// @description returns the room y position as the position on the gui relative to camera
	/// @param {Real} _y
	/// @returns {Real}
	/// @ignore
	static room_to_gui_y = function(_y){
		return ((_y - get_y() - y_frac) / get_zoom_y()) * stanncam_get_gui_scale_y();
	}
	
	/// @function room_to_display_x
	/// @description returns the room x position as the position on the display relative to camera
	/// @param {Real} _x
	/// @returns {Real}
	// function room_to_display_x(_x){
	// 	return (_x - get_x()) * stanncam_get_res_scale_x() / zoom_amount;
	// }
	
	/// @function room_to_display_y
	/// @description returns the room y position as the position on the display relative to camera
	/// @param {Real} _y
	/// @returns {Real}
	//function room_to_display_y(_y){
	//	return (_y - get_y()) * stanncam_get_res_scale_y() / zoom_amount;
	//}
	
	/// @function out_of_bounds
	/// @description returns if the position is outside of camera bounds
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_margin=0]
	/// @returns {Bool}
	/// @ignore
	static out_of_bounds = function(_x, _y, _margin=0){
		var _cam_x = get_x();
		var _cam_y = get_y();
		var _col = //uses camera view bounding box
			(_x < (_cam_x + _margin)) ||
			(_y < (_cam_y + _margin)) ||
			(_x > ((_cam_x + (width * zoom_amount)) - _margin)) ||
			(_y > ((_cam_y + (height * zoom_amount)) - _margin))
		;

		return _col;
	}
	
	/// @function destroy
	/// @description marks the stanncam as destroyed
	/// @ignore
	static destroy = function(){
		camera_destroy(__camera);
		global.stanncams[cam_id] = -1;
		view_camera[cam_id] = -1;
		view_visible[cam_id] = false;
		--__obj_stanncam_manager.number_of_cams;
		follow = undefined;
		if(surface_exists(surface)) surface_free(surface);
		if(surface_exists(surface_extra)) surface_free(surface_extra);
		if(surface_exists(__surface_special)) surface_free(__surface_special);
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
	static __check_surface = function(){
		if(use_app_surface){
			surface = application_surface;
		} else {
			if (!surface_exists(surface)){
				surface = surface_create(width, height);
			}
		}
		
		if(surface_extra_on && !surface_exists(surface_extra)){
			surface_extra = surface_create(width, height);
		}
	}
	
	/// @function __predraw
	/// @description clears the surface
	/// @ignore
	static __predraw = function(){
		__check_surface();
		if(surface_extra_on){
			surface_copy(surface_extra, 0, 0, surface);
		}
		surface_set_target(surface);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
		view_set_surface_id(cam_id, surface);
	}
	
	/// @function __update_view_size
	/// @description updates the view size
	/// @param {Bool} [_force=false]
	/// @ignore
	static __update_view_size = function(_force=false){
		//if smooth_draw is off maintains pixel perfection even when zooming in and out
		//if on it is handled by the draw events
		if(smooth_draw){
			var _ceiled_zoom = ceil(zoom_amount); //ensures the new surface size is a whole number
			var _new_width = width * _ceiled_zoom;
			var _new_height = height * _ceiled_zoom;
		} else {
			var _new_width  = floor(width * zoom_amount);
			var _new_height = floor(height * zoom_amount);
			
			var _width_2px = _new_width mod 2;
			var _height_2px = _new_height mod 2;
			
			_new_width  = _new_width - _width_2px;
			_new_height = _new_height - _height_2px;
		}
		//only runs if the size has changed (unless forced, used by __check_viewports to initialize)
		if(_force || surface_get_width(surface) != _new_width || surface_get_height(surface) != _new_height){
			__check_surface();
			surface_resize(surface,	_new_width, _new_height);
			camera_set_view_size(__camera, _new_width, _new_height);
		}
}

	/// @function __update_view_pos
	/// @description updates the view position
	/// @ignore
	static __update_view_pos = function(){
		//update camera view
		var _new_x = x + offset_x - (width * 0.5) + __shake_x;
		var _new_y = y + offset_y - (height * 0.5) + __shake_y;
		
		if(!smooth_draw){ // when smooth draw is off, the actual camera position gets rounded to whole numbers
			_new_x = round(_new_x);
			_new_y = round(_new_y);
		}
		
		//apply zoom offset
		_new_x -= zoom_x;
		_new_y -= zoom_y;
				
		//var zones = ds_list_create();
		//zone constricting
		//instance_place_list(follow.x,follow.y,obj_stanncam_zone,zones,false);
		if(__zone != noone){				
			if(__zone.constrain_dimension == "Horizontal" || __zone.constrain_dimension == "Both"){
				
				var left =   max(0, __zone.bbox_left - _new_x);
				var right = -max(0, _new_x + (width * zoom_amount) - __zone.bbox_right );
				
				if(__zone.sprite_width <= (width*zoom_amount)){
					var _constrained_x = __zone.x - (width*zoom_amount)/2;
				} else {
					var _constrained_x = _new_x+left+right; 
				}
				_new_x = lerp(_new_x,_constrained_x,__zone_constrain_amount);
			}
			
			if(__zone.constrain_dimension == "Vertical" || __zone.constrain_dimension == "Both"){
				var top =     max(0,__zone.bbox_top - _new_y);
				var bottom = -max(0,_new_y+(height*zoom_amount) - __zone.bbox_bottom);
				
				if(__zone.sprite_height <= (height*zoom_amount)){
					var _constrained_y = __zone.y - (height*zoom_amount)/2;
				} else {
					var _constrained_y = _new_y+top+bottom;
				}
				_new_y = lerp(_new_y,_constrained_y,__zone_constrain_amount);
			}
		}
		
		//Constrains camera to room
		if(room_constrain){
			constrain_offset_x = (clamp(_new_x, 0, room_width  - width*zoom_amount ) - _new_x);
			constrain_offset_y = (clamp(_new_y, 0, room_height - height*zoom_amount) - _new_y);
			
			_new_x += constrain_offset_x;
			_new_y += constrain_offset_y;
		} else {
			constrain_offset_x = 0;
			constrain_offset_y = 0;
		}
		
		if(smooth_draw){
			//seperates position into whole and fractional parts
			x_frac = frac(_new_x);
			y_frac = frac(_new_y);
			
			_new_x = floor(abs(_new_x)) * sign(_new_x);
			_new_y = floor(abs(_new_y)) * sign(_new_y);
			
		} else {
			_new_x = ceil(_new_x);
			_new_y = ceil(_new_y);
		}
		
		camera_set_view_pos(__camera, _new_x, _new_y);
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
				
				var _pre_color = draw_get_color();
				
				var _x1 = (width * 0.5) - bounds_w - offset_x - constrain_offset_x + zoom_x;
				var _x2 = (width * 0.5) + bounds_w - offset_x - constrain_offset_x + zoom_x;
				var _y1 = (height * 0.5) - bounds_h - offset_y - constrain_offset_y + zoom_y;
				var _y2 = (height * 0.5) + bounds_h - offset_y - constrain_offset_y + zoom_y;
				draw_set_color(c_white);
				draw_rectangle(_x1, _y1, _x2, _y2, true);
				
				
				draw_set_color(c_red);
				
				//top
				if(bounds_dist_h != 0){
					if(bounds_dist_h < 0){
						//bottom
						draw_line(_x1, _y1, _x2, _y1);
					} else {
						draw_line(_x1, _y2, _x2, _y2);
					}
				}
				
				//left
				if(bounds_dist_w != 0){
					if(bounds_dist_w < 0){
						//right
						draw_line(_x1, _y1, _x1, _y2);
					} else {
						draw_line(_x2, _y1, _x2, _y2);
					}
				}
				
				draw_set_color(_pre_color);
				surface_reset_target();
			}
		}
	}
	
	/// @function draw
	/// @description draws stanncam
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_scale_x=1]
	/// @param {Real} [_scale_y=1]
	/// @ignore
	static draw = function(_x, _y, _scale_x=1, _scale_y=1){
		__check_surface();
		__debug_draw();
		draw_surf(surface, _x, _y, _scale_x, _scale_y, 0, 0, width, height);
	}
	
	/// @function draw_part
	/// @description draws part of stanncam
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} _left
	/// @param {Real} _top
	/// @param {Real} _width
	/// @param {Real} _height
	/// @param {Real} [_scale_x=1]
	/// @param {Real} [_scale_y=1]
	/// @ignore
	static draw_part = function(_x, _y, _left, _top, _width, _height, _scale_x=1, _scale_y=1){
		__check_surface();
		__debug_draw();
		draw_surf(surface, _x, _y, _scale_x, _scale_y, _left, _top, _width, _height);
	}
	
	/// @function draw_special
	/// @description pass in draw commands, and have them be scaled to match the stanncam
	/// @param {Function} _draw_func
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_surf_width=width]
	/// @param {Real} [_surf_height=height]
	/// @param {Real} [_scale_x=1]
	/// @param {Real} [_scale_y=1]
	/// @ignore
	static draw_special = function(_draw_func, _x, _y, _surf_width=width, _surf_height=height, _scale_x=1, _scale_y=1){
		var _surf_width_scaled = floor(_surf_width * zoom_amount);
		var _surf_height_scaled = floor(_surf_height * zoom_amount);
		if(surface_exists(__surface_special)){
			if((surface_get_width(__surface_special) != _surf_width_scaled) || (surface_get_height(__surface_special) != _surf_height_scaled)){
				surface_free(__surface_special);
			}
		}
		if(!surface_exists(__surface_special)){
			__surface_special = surface_create(_surf_width_scaled, _surf_height_scaled);
		}
		surface_set_target(__surface_special);
		draw_clear_alpha(c_black, 0);
		_draw_func();
		surface_reset_target();
		draw_surf(__surface_special, _x, _y, _scale_x, _scale_y, 0, 0, _surf_width, _surf_height);
	}
	
	/// @function draw_surf
	/// @description draws the supplied surface with the proper size and scaling
	/// @param {Id.Surface} _surface
	/// @param {Real} _x
	/// @param {Real} _y
	/// @param {Real} [_scale_x=1]
	/// @param {Real} [_scale_y=1]
	/// @param {Real} [_left=0]
	/// @param {Real} [_top=0]
	/// @param {Real} [_width=surface_get_width(_surface)]
	/// @param {Real} [_height=surface_get_height(_surface)]
	/// @ignore
	static draw_surf = function(_surface, _x, _y, _scale_x=1, _scale_y=1, _left=0, _top=0, _width=surface_get_width(_surface), _height=surface_get_height(_surface)){
		//offsets position to match with display resoultion
		_x *= (global.res_w / global.game_w);
		_y *= (global.res_h / global.game_h);
		
		_x += stanncam_fullscreen_ratio_compensate_x();
		_y += stanncam_fullscreen_ratio_compensate_y();
		
		if(smooth_draw){
		//draws super smooth both when moving and zooming
			_width *= zoom_amount;
			_height *= zoom_amount;
			_scale_x /= zoom_amount;
			_scale_y /= zoom_amount;
			
			draw_surface_part_ext(_surface, x_frac + _left, y_frac + _top, _width, _height, _x, _y, __obj_stanncam_manager.__display_scale_x * _scale_x, __obj_stanncam_manager.__display_scale_y * _scale_y, -1, 1);
		} else {
		//maintains pixel perfection when moving and zooming, appears more stuttery
			draw_surface_stretched(_surface, _x, _y, _width * __obj_stanncam_manager.__display_scale_x * _scale_x, _height * __obj_stanncam_manager.__display_scale_y * _scale_y);
		}
		
	}
#endregion

	/**
	 * @function toString
	 * @returns {String}
	 */
	static toString = function() {
		return "<stanncam[" + string(cam_id) + "] (" + string(width) + ", " + string(height) + ")>";
	}

}
