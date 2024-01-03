//toggle following player
if(keyboard_check_pressed(vk_space)){
	if(cam1.follow != undefined){
		cam1.follow = undefined;
	} else {
		cam1.follow = obj_player;
	}
}

//toggle splitscreen
if(keyboard_check_pressed(vk_f5)){
	split_screen = !split_screen;
	if(split_screen){
		cam1.set_size(global.game_w * 0.5, global.game_h);
		
		cam2 = cam1.clone();
		cam2.follow = obj_player2;
	} else {
		if(!cam2.is_destroyed()) cam2.destroy();
		cam1.set_size(global.game_w, global.game_h);
	}
}

//toggle hires gui
if(keyboard_check_pressed(vk_alt)){
	gui_hires = !gui_hires;
	if(gui_hires){
		stanncam_set_gui_resolution(1920, 1080);
	} else {
		stanncam_set_gui_resolution(global.game_w, global.game_h);
	}
}

//moves camera to mouse press location
if(mouse_check_button_pressed(mb_left)){
	var _x = cam1.get_mouse_x();
	var _y = cam1.get_mouse_y();
	
	cam1.move(_x, _y, GAME_SPEED * 1);
	alarm[0] = GAME_SPEED * 1.1;
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
			cam1.zoom(1, GAME_SPEED * 1);
			obj_tv.tv.zoom(1, GAME_SPEED * 1);
			break;
		case 1:
			//zoom in
			cam1.zoom(0.5, GAME_SPEED * 1);
			obj_tv.tv.zoom(0.5, GAME_SPEED * 1);
			break;
		case 2:
			//zoom out
			cam1.zoom(2, GAME_SPEED * 1);
			obj_tv.tv.zoom(2, GAME_SPEED * 1);
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
			cam1.set_speed(0.5, 50);
			break;
		case 1:
			//speed 1
			cam1.set_speed(1, 50);
			break;
		case 2:
			//speed 2
			cam1.set_speed(2, 50);
			break;
		case 3:
			//speed 10
			cam1.set_speed(10, 50);
			break;
	}
}

//toggle if the camera is constrained to the room size
if(keyboard_check_pressed(vk_control)){
	cam1.room_constrain = !cam1.room_constrain;
}

//do a screenshake
if(keyboard_check_pressed(ord("F"))){
	cam1.shake_screen(30, GAME_SPEED * 1);
}

//Toggle smooth camera
if(keyboard_check_pressed(ord("B"))){
	cam1.smooth_draw = !cam1.smooth_draw;
}

