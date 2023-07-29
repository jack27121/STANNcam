/// @description

parralax_bg = function(cam_){
	
	//the background is scaled up so it appears smooth when being parralaxed
	
	var scalex = stanncam_get_res_scale_x();
	var scaley = stanncam_get_res_scale_y();
	
	//the offset the camera is from the middle of the room
	var offset_x = (-cam_.get_x() -cam_.__x_frac) * scalex;
	var pos_x = -200 + cam_.__x_frac;
	var pos_y = 0  + cam_.__y_frac;
	
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

//fancy splitscreen rendering
var width = global.res_w;
var height = global.res_h;

//the parralax drawing is scaled down again
var scalex = 1/stanncam_get_res_scale_x();
var scaley = 1/stanncam_get_res_scale_y();

if(!split_screen){
	cam1.draw_special(parralax_bg1,0,0,width,height,scalex,scaley);
	cam1.draw(0,0);
} else {
//fancy splitscreen rendering
	
	cam1.draw_special(parralax_bg1,0,0,width/2,height,scalex,scaley);
	cam1.draw(0,0);
	
	cam2.draw_special(parralax_bg2,global.game_w/2,0,width/2,height,scalex,scaley);
	cam2.draw(global.game_w/2,0);
}