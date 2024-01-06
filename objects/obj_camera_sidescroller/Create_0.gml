//camera
game_res = stanncam_get_preset_resolution(STANNCAM_RES_PRESETS.GAME_BOY_ADVANCE_160P);
resolution = stanncam_get_preset_resolution(STANNCAM_RES_PRESETS.DESKTOP_1080P);

resoulution_array = stanncam_get_preset_resolution_range(STANNCAM_RES_PRESETS.DESKTOP_720P,STANNCAM_RES_PRESETS.DESKTOP_4K)
array_insert(resoulution_array,0, //adds custom resolution to the array
	{
		width: 400,
		height: 400
	}
);

gui_resolution_array = stanncam_get_preset_resolution_range(); //gets all the presets

stanncam_init(game_res.width, game_res.height, 1920, 1080);

cam1 = new stanncam(obj_player_sidescroller.x, obj_player_sidescroller.y, global.game_w, global.game_h);
cam1.follow = obj_player_sidescroller;
cam1.room_constrain = true;

cam2 = cam1.clone();
cam2.follow = obj_player_sidescroller2;
cam2.set_size(global.game_w * 0.5, global.game_h, 0);

split_screen = false;

//pointer
zoom_text = cam1.zoom_amount;

speed_mode = 1;
zoom_mode = 1;

game_res = 2;
gui_hires = false;
gui_res = 0;

lookahead = false;

surface = -1;


parralax_bg = function(_cam){
	//the background is scaled up so it appears smooth when being parralaxed
	var _scalex = stanncam_get_res_scale_x();
	var _scaley = stanncam_get_res_scale_y();
	
	//the offset the camera is from the middle of the room
	var _offset_x = (-_cam.get_x() - _cam.x_frac) * _scalex;
	var _pos_x = -200 + _cam.x_frac;
	var _pos_y = 0 + _cam.y_frac;
	
	draw_sprite_ext_tiled(spr_underwater_layer00, 0, _pos_x + (_offset_x * 0.0), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer01, 0, _pos_x + (_offset_x * 0.2), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer02, 0, _pos_x + (_offset_x * 0.4), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer03, 0, _pos_x + (_offset_x * 0.6), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer04, 0, _pos_x + (_offset_x * 0.8), _pos_y, 2, 1, _scalex, _scaley);
	draw_sprite_ext_tiled(spr_underwater_layer05, 0, _pos_x + (_offset_x * 1.0), _pos_y, 2, 1, _scalex, _scaley);
}

parralax_bg1 = function(){
	parralax_bg(cam1);
}

parralax_bg2 = function(){
	parralax_bg(cam2);
}
