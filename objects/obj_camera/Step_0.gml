/// @description
//toggle following player
if(keyboard_check_pressed(vk_space)){
	if(cam1.follow != undefined) cam1.follow = undefined;
	else cam1.follow = obj_player;
}
	
//toggle splitscreen
if(keyboard_check_pressed(vk_f5)){
	split_screen = !split_screen;
	if(split_screen){
		cam1.set_size(global.game_w/2,global.game_h);
		
		cam2 = cam1.clone();
		cam2.follow = obj_player2;
	}else{
		if(!cam2.is_destroyed()) cam2.destroy();
		cam1.set_size(global.game_w,global.game_h);
	}
}

//toggle hires gui
if(keyboard_check_pressed(vk_alt)){
	gui_hires = !gui_hires;
	if(gui_hires){
		stanncam_set_gui_resolution(1920,1080);
	}else{
		stanncam_set_gui_resolution(global.game_w,global.game_h);
	}
}

//moves camera to mouse press location
if(mouse_check_button_pressed(mb_left)){
	var _x = cam1.get_mouse_x();
	var _y = cam1.get_mouse_y();
	
	cam1.move(_x,_y,game_speed*1);
	alarm[0] = game_speed*1.1;
	pointer = true;
	pointer_x = cam1.get_mouse_x();
	pointer_y = cam1.get_mouse_y();
}

//toggle zoom in
if(mouse_check_button_pressed(mb_right)){
	zoom_mode++;
	if(zoom_mode > 2) zoom_mode = 0;
	
	switch (zoom_mode) {
	    case 0:
			//no zooming
	        cam1.zoom(1,game_speed*1);
			obj_tv.tv.zoom(1,game_speed*1);
	        break;
	    case 1:
			//zoom in
	        cam1.zoom(0.5,game_speed*1);
			obj_tv.tv.zoom(0.5,game_speed*1);
	        break;
		case 2:
			//zoom out
	        cam1.zoom(2,game_speed*1);
			obj_tv.tv.zoom(2,game_speed*1);
	        break;
	}
}
zoom_text = cam1.zoom_amount;

//toggle camera speed
if(keyboard_check_pressed(vk_tab)){
	speed_mode++;
	if(speed_mode > 3) speed_mode = 0;
	
	switch (speed_mode) {
	    case 0:
			//speed 0.5
	        cam1.set_speed(0.5,50);
	        break;
	    case 1:
			//speed 2
	        cam1.set_speed(1,50);
	        break;
		case 2:
			//speed 10
	        cam1.set_speed(2,50);
	        break;
		case 3:
			//speed 10
	        cam1.set_speed(10,50);
	        break;
	}
}

//toggle if the camera is constrained to the room size
if(keyboard_check_pressed(vk_control)){
	if(cam1.room_constrain) cam1.room_constrain = false;
	else cam1.room_constrain = true;
}

//do a screenshake
if(keyboard_check_pressed(ord("F"))){
	cam1.shake_screen(30,game_speed*1);
}

//switch resolutions
if(keyboard_check_pressed(vk_f1))
{
	game_res++;
	if(game_res > 6) game_res = 0;
	stanncam_set_resolution(resolutions[game_res].w,resolutions[game_res].h);
}

//switch gui resolutions
if(keyboard_check_pressed(vk_f2)){
	gui_res++
	if(gui_res > 6) gui_res = 0;
	var gui_w = resolutions[gui_res].w;
	var gui_h = resolutions[gui_res].h;
	stanncam_set_gui_resolution(gui_w,gui_h);
}

//toggle keep aspect ratio
if(keyboard_check_pressed(vk_f3)){
	stanncam_set_keep_aspect_ratio( !stanncam_get_keep_aspect_ratio() );
}

//toggle between window modes
if(keyboard_check_pressed(vk_f4)){
	var window_mode = global.window_mode;
	window_mode++;
	if (window_mode == 3) window_mode = 0;
	
	stanncam_set_window_mode(window_mode)
}