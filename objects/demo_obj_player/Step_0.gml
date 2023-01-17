/// @description
hspd = (keyboard_check_direct(vk_right) - keyboard_check_direct(vk_left)) * spd;
vspd = (keyboard_check_direct(vk_down) - keyboard_check_direct(vk_up)) * spd;

x+= hspd;
y+= vspd;

x = clamp(x,0,room_width);
y = clamp(y,0,room_height);

//toggle following player
if(keyboard_check_pressed(vk_space)){
	if(global.camera_follow != undefined) global.camera_follow = undefined;
	else global.camera_follow = demo_obj_player;
}

//toggle hires gui
if(keyboard_check_pressed(vk_alt)){
	if(obj_stanncam.gui_hires) obj_stanncam.gui_hires = false
	else obj_stanncam.gui_hires = true;
	stanncam_update_resolution();
}

//moves camera to mouse press location
if(mouse_check_button_pressed(mb_left)){
	stanncam_move(mouse_x,mouse_y,room_speed*1);
	alarm[0] = room_speed*1.1;
	pointer = true;
	pointer_x = mouse_x;
	pointer_y = mouse_y;
}

//toggle zoom in
if(mouse_check_button_pressed(mb_right)){
	zoom_mode++;
	if(zoom_mode > 2) zoom_mode = 0;
	
	switch (zoom_mode) {
	    case 0:
			//no zooming
			zoom_text = "no zooming";
	        stanncam_zoom(1,room_speed*1);
	        break;
	    case 1:
			//zoom in
			zoom_text = "zoomed in";
	        stanncam_zoom(0.5,room_speed*1);
	        break;
		case 2:
			//zoom out
			zoom_text = "zoomed out";
	        stanncam_zoom(2,room_speed*1);
	        break;
	}
}

//toggle if the camera is constrained to the room size
if(keyboard_check_pressed(vk_control)){
	if(obj_stanncam.camera_constrain) obj_stanncam.camera_constrain = false;
	else obj_stanncam.camera_constrain = true;
	
}

//switch resolutions
if(keyboard_check_pressed(vk_f1))
{
	game_res++
	if(game_res > 6) game_res = 0;
	global.view_w = resolutions[game_res].w;
	global.view_h = resolutions[game_res].h;
	stanncam_update_resolution();
}

//switch gui resolutions
if(keyboard_check_pressed(vk_f2)){
	gui_res++
	if(gui_res > 6) gui_res = 0;
	global.gui_w = resolutions[gui_res].w;
	global.gui_h = resolutions[gui_res].h;
	stanncam_update_resolution();
}

//switch upscaling
if(keyboard_check_pressed(vk_f3)) {
	global.upscale++;
	if(global.upscale > 4) global.upscale = 1;
	stanncam_update_resolution();
}

//toggle fullscreen
if(keyboard_check_pressed(vk_f4)) stanncam_toggle_fullscreen();


//Restart
if(keyboard_check_pressed(ord("R"))) game_restart();