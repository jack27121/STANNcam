/// @description
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