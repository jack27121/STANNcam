/// @description
//camera
stanncam_init(400,270,1920,1080);
cam1 = new stanncam(obj_player_sidescroller.x,obj_player_sidescroller.y,global.game_w,global.game_h);
cam1.follow = obj_player_sidescroller;
cam1.room_constrain = true;

cam2 = cam1.clone();
cam2.follow = obj_player_sidescroller2;
cam2.set_size(global.game_w/2,global.game_h,0);

split_screen = false;

//pointer
zoom_text = cam1.zoom_amount

speed_mode = 1;
zoom_mode = 1;

game_res = 2;
gui_hires = false;
gui_res = 0;

resolutions = [
{ w:400 ,  h:400 }, //1:1
{ w:500 ,  h:250 }, //2:1
{ w:320 ,  h:180 }, //16:9
{ w:640 ,  h:360 },
{ w:1280 , h:720 },
{ w:1920 , h:1080 },
{ w:2560 , h:1440 }
]

lookahead = false;

surface = -1;


parralax_bg = function(cam_){
	
	//the background is scaled up so it appears smooth when being parralaxed
	
	var scalex = stanncam_get_res_scale_x();
	var scaley = stanncam_get_res_scale_y();
	
	//the offset the camera is from the middle of the room
	var offset_x = (-cam_.get_x() -cam_.x_frac) * scalex;
	var pos_x = -200 + cam_.x_frac;
	var pos_y = 0  + cam_.y_frac;
	
	draw_sprite_ext_tiled(spr_underwater_layer00,0,pos_x + (offset_x * 0.0),pos_y,2,1,scalex,scaley);
	draw_sprite_ext_tiled(spr_underwater_layer01,0,pos_x + (offset_x * 0.2),pos_y,2,1,scalex,scaley);
	draw_sprite_ext_tiled(spr_underwater_layer02,0,pos_x + (offset_x * 0.4),pos_y,2,1,scalex,scaley);
	draw_sprite_ext_tiled(spr_underwater_layer03,0,pos_x + (offset_x * 0.6),pos_y,2,1,scalex,scaley);
	draw_sprite_ext_tiled(spr_underwater_layer04,0,pos_x + (offset_x * 0.8),pos_y,2,1,scalex,scaley);
	draw_sprite_ext_tiled(spr_underwater_layer05,0,pos_x + (offset_x * 1.0),pos_y,2,1,scalex,scaley);
}

parralax_bg1 = function(){
	parralax_bg(cam1);
}
	
parralax_bg2 = function(){
	parralax_bg(cam2);
}