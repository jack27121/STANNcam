function stanncam_init(game_w,game_h,resolution_w=game_w,resolution_h=game_h){ //stanncam manager gets created automatically
	instance_create_layer(0,0,"instances",obj_stanncam_manager);
	global.stanncams = [];
	global.game_w = game_w;
	global.game_h = game_h;
	obj_stanncam_manager.resolution_w = resolution_w;
	obj_stanncam_manager.resolution_h = resolution_h;
	application_surface_draw_enable(false);
	stanncam_update_resolution();
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
	if(window_get_fullscreen())	{			
		global.res_w = display_get_width();
		global.res_h = display_get_height();
	} else {		
		global.res_w = obj_stanncam_manager.resolution_w;
		global.res_h = obj_stanncam_manager.resolution_h;
		
		window_set_size(global.res_w, global.res_h);
		call_later(1,time_source_units_frames,function(){
			window_center();
		});
	}
	
	for (var i = 0; i < array_length(global.stanncams); ++i) {  
		global.stanncams[i].update_resolution();
	}
}