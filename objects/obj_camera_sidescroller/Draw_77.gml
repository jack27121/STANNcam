/// @description

//background
if(!surface_exists(bg_surf)){
	bg_surf = surface_create(global.game_w,global.game_h);
}

surface_set_target(bg_surf);

//the offset the camera is from the middle of the room
var offset_x = cam1.x - (room_width/2);
var offset_y = cam1.y - (room_width/2);

var pos_x = (global.game_w/2);
var pos_y = (-140);

draw_clear(c_blue);
draw_sprite_ext(spr_underwater_layer00,0,	(pos_x-offset_x) * 0.0,	(pos_y - offset_y) * 0.0,	4,	1,	0,	c_white,	1);
draw_sprite_ext(spr_underwater_layer01,0,	(pos_x-offset_x) * 0.2,	(pos_y - offset_y) * 0.2,	4,	1,	0,	c_white,	1);
draw_sprite_ext(spr_underwater_layer02,0,	(pos_x-offset_x) * 0.4,	(pos_y - offset_y) * 0.4,	4,	1,	0,	c_white,	1);
draw_sprite_ext(spr_underwater_layer03,0,	(pos_x-offset_x) * 0.6,	(pos_y - offset_y) * 0.6,	4,	1,	0,	c_white,	1);
draw_sprite_ext(spr_underwater_layer04,0,	(pos_x-offset_x) * 0.8,	(pos_y - offset_y) * 0.8,	4,	1,	0,	c_white,	1);
draw_sprite_ext(spr_underwater_layer05,0,	(pos_x-offset_x) * 1.0,	(pos_y - offset_y) * 1.0,	4,	1,	0,	c_white,	1);

surface_reset_target();

draw_surface_stretched(bg_surf,0,0,global.res_w,global.res_h);

//foreground
cam1.draw(0,0);