/// @function stanncam()
/// @description creates a new stanncam
function stanncam(x_ = 0,y_ = 0,width_ = 1920,height_ = 1080) constructor{
	#region init
	//whenever a new cam is created number_of_cams gets incremented
	static number_of_cams = 0;	
	cam_id = number_of_cams;
	
	//checks if there's already 8 cameras
	if(cam_id == 8){
		show_error("There can maximum be 8 cameras",true);
	}
	number_of_cams++;
	array_push(global.stanncams,self);
	#endregion
	
	#region variables
	x = x_;
	y = y_;
	width = width_;
	height = height_;
	
	spd = 10; //how fast the camera follows an object
	spd_threshold = 50; //the minimum distance the camera is away, for the speed to be in full effect
	camera_constrain = false; //if camera should be constrained to the room size
	//the camera bounding box, for the followed object to leave before the camera starts moving
	bounds_w = 20;
	bounds_h = 20;
	
	surf = -1;
	
	check_surface();
	check_viewports();
	update_resolution();
	
	#region animation variables
	
	//moving
	xStart = x;
	yStart = y;
	xTo = x;
	yTo = y;
	follow = -1;
	duration = 0;
	t = 0;
	
	//zoom
	zoom = 1;
	zoom_x = 0;
	zoom_y = 0;
	zooming = false;
	t_zoom = 0;
	zoomStart = 0;
	zoomTo = 0;
	zoom_duration = 0;
	
	//screen shake
	shake_length = 0;
	shake_magnitude = 0;
	shake_time = 0;
	shake_x = 0;
	shake_y = 0;
	
	moving = false;
	#endregion
	
	#endregion

	#region Step
	//gets called every step
	static step = function(){
		if (instance_exists(follow)){
	
		//update destination
		xTo = follow.x;
		yTo = follow.y;
		
		var dist_w = max(bounds_w,abs(xTo - x)) - bounds_w;
		var dist_h = max(bounds_h,abs(yTo - y)) - bounds_h;
		
		//update camera position
		if (abs(xTo - x) > bounds_w){
			var _spd = (dist_w/spd_threshold)*spd;
			if (x < xTo) x+=_spd;
			else if (x > xTo) x-=_spd;
		}
		
		if (abs(y - yTo) > bounds_h){
			var _spd = (dist_h/spd_threshold)*spd;
			if (y < yTo) y+=_spd;
			else if (y > yTo) y-=_spd;
		}
		
		} else if(moving){
			//gradually moves camera into position based on duration
			x = ease_in_out(t,xStart,xTo-xStart,duration);
			y = ease_in_out(t,yStart,yTo-yStart,duration);
		
			t++;
			if(x == xTo && y == yTo) moving = false;
		}
		
		#region screen-shake
		var stanncam_shake_ = shake(shake_time++,shake_magnitude,shake_length);
		shake_x = stanncam_shake_;
		shake_y = stanncam_shake_;
		#endregion
		
		#region constrains camera to room bounds
		if(camera_constrain){
			x = clamp(x,(width/2),room_width -(width/2));
			y = clamp(y,(height/2),room_height-(height/2));
		}
		#endregion
		
		#region zooming
		if(zooming){
			//gradually zooms camera
			zoom = ease_in_out(t_zoom,zoomStart,zoomTo-zoomStart,zoom_duration);
			t_zoom++;
			if(zoom == zoomTo) zooming = false;
			camera_set_view_size(view_camera[cam_id],width*zoom,height*zoom);
			zoom_x = ((width*zoom) - width)/2;
			zoom_y = ((height*zoom) - height)/2;
		}
		#endregion
		
		//update camera view
		var new_x = x - (width / 2 + shake_x + zoom_x);
		var new_y = y - (height / 2 + shake_y + zoom_y);
		
		camera_set_view_pos(view_camera[cam_id], new_x, new_y);
	}
	#endregion
	
	#region Drawing functions
	
	/// @function draw()
	/// @param x_ position
	/// @param y_ position
	/// @description draws camera
	static draw = function(x_,y_){
		check_surface();
		x_ *= (global.res_w / global.game_w);
		y_ *= (global.res_h / global.game_h);
		draw_surface_stretched(surf,x_,y_,display_width,display_height);
	}
	
	/// @function draw_stretched()
	/// @param x_ position
	/// @param y_ position
	/// @param w_ width
	/// @param h_ height
	/// @description draws camera stretched
	static draw_stretched = function(x_,y_,w,h){
		check_surface();
		x_ *= (global.res_w / global.game_w);
		y_ *= (global.res_h / global.game_h);
		w *= (global.res_w / global.game_w);
		h *= (global.res_h / global.game_h);
		draw_surface_stretched(surf,x_,y_,w,h);
	}
	
	/// @function draw_fill()
	/// @description draws camera to fill the entire game window
	static draw_fill = function(){
		check_surface();
		draw_surface_stretched(surf,0,0,global.res_w,global.res_h);
	}
	#endregion
	
	#region Dynamic functions
	
	/// @function shake(magnitude, duration);
	/// @description makes the camera shake
	/// @param	magnitude
	/// @param	duration in frames
	shake = function(magnitude, duration) {
		shake_magnitude =+ magnitude;
		shake_length =+ duration;
		shake_time = 0;
	}
	
	/// @function move(_x,_y,duration)
	/// @description moves the camera to x y
	/// @param _x
	/// @param _y
	/// @param _duration
	move = function(_x, _y, _duration){
		if(_duration == 0){
			x = _x;
			y = _y;
		}else{
			moving = true;
			t = 0;
			xStart = x;
			yStart = y;
			
			xTo = _x;
			yTo = _y;
			duration = _duration;
		}
	}
	
	/// @function zoom(_zoom,zoom_duration)
	/// @description zooms the camera
	/// @param _zoom
	/// @param duration
	zoom = function(_zoom, _duration){
		if(_duration == 0){
			zoom = _zoom;
			camera_set_view_size(view_camera[cam_id],width*_zoom,height*_zoom);
			
		} else {
			zooming = true;
			t_zoom = 0;
			zoomStart = zoom;
		}
		zoomTo = _zoom;
		zoom_duration = _duration;
	}
	
	/// @function set_speed(spd,threshold)
	/// @description changes the speed of the camera
	/// @param spd how fast the camera can move
	/// @param threshold minimum distance for the speed to have full effect
	set_speed = function(spd,threshold){
		spd = spd;	
		spd_threshold = threshold;
	}
	
	/// @function pos_x()
	/// @description get camera corner x position. if need the middle of the camera use x
	pos_x = function(){
		return camera_get_view_x(view_camera[cam_id]);
	}
	
	/// @function pos_y()
	/// @description get camera corner y position. if need the middle of the camera use y
	pos_y = function(){
		return camera_get_view_y(view_camera[cam_id]);
	}
	#endregion
	
	
	
	#region Internal functions	
	//enables viewports and sets viewports size
	static check_viewports = function(){
		view_visible[cam_id] = true;
		camera_set_view_size(view_camera[cam_id],width,height);
	}
	
	//checks if surface exists and else creates it and attaches it
	static check_surface = function(){
		if (!surface_exists(surf)){
			surf = surface_create(width,height);
			view_set_surface_id(cam_id,surf);
		}
	}
	
	//updates cameras drawing resolution
	static update_resolution = function(){
		display_width =  width  * (global.res_w / global.game_w);
		display_height = height * (global.res_h / global.game_h);
	}
	#endregion
}