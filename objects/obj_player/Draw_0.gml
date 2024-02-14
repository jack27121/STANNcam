if(hspd != 0 || vspd != 0){
	draw_sprite(spr_player_moving, subimg, x, y);
} else {
	draw_sprite(spr_player_idle, image_index, x, y);
}
subimg += anim_spd;
