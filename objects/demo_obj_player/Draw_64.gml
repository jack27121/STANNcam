/// @description

//chooses pixel font or hires font
if(obj_stanncam.gui_hires){
	draw_set_font(demo_f_hires);
	var offset = 32;
	var outline_width = 4;
	draw_set_color(c_white)
} else {
	draw_set_font(demo_f_pixel);
	var offset = 8;
	var outline_width = 0;
	draw_set_color(c_black)
}

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1,1,"[arrow keys] move character",outline_width);
var following = (global.camera_follow != undefined) ? "following" : "not following"
draw_text_outline(1,offset,"[space] " + following,outline_width);
draw_text_outline(1,offset*2,"[ALT] toggle hi-res GUI",outline_width);
draw_text_outline(1,offset*3,"[LMB] move cam to pos (when not following)",outline_width);
draw_text_outline(1,offset*4,"[RMB] "+ zoom_text,outline_width);
var constrained = (obj_stanncam.camera_constrain) ? "camera constrained to room" : "camera not constrained to room";
draw_text_outline(1,offset*5,"[CTRL] "+ constrained,outline_width);

//draw current resolution text
draw_set_halign(fa_right)
draw_text_outline(display_get_gui_width()-1,1,"game resolution: "+string(global.view_w)+" x "+string(global.view_h)+" [F1]",outline_width);
draw_text_outline(display_get_gui_width()-1,offset,"GUI resolution: "+string(display_get_gui_width())+" x "+string(display_get_gui_height())+" [F2]",outline_width);
draw_text_outline(display_get_gui_width()-1,offset*2,"upscale: "+string(global.upscale)+" [F3]",outline_width);
draw_text_outline(display_get_gui_width()-1,offset*3,"fullscreen: "+string(window_get_fullscreen())+" [F4]",outline_width);


//draws pointer over players head
if(obj_stanncam.gui_hires){
	draw_sprite_ext(spr_arrow,1,room_to_gui_x(x),room_to_gui_y(y)-64,0.5,0.5,180,-1,1);
} else {
	draw_sprite_ext(spr_arrow_small,1,room_to_gui_x(x),room_to_gui_y(y)-12,1,1,180,-1,1);
}


//point at player, when it's outside camera bounds
if(out_cam_bounds(8)){
	var _x = room_to_gui_x(x);
	var _y = room_to_gui_y(y);
	
	var margin = (obj_stanncam.gui_hires) ? 50 : 20;
	
	_x = clamp(_x,margin,display_get_gui_width() -margin);
	_y = clamp(_y,margin,display_get_gui_height()-margin);
	
	var dir = point_direction(_x,_y,room_to_gui_x(x),room_to_gui_y(y));

	if(obj_stanncam.gui_hires){
		draw_sprite_ext(spr_arrow,0,_x,_y,1,1,dir-90,-1,1);
	}else{
		draw_sprite_ext(spr_arrow_small,0,_x,_y,1,1,dir-90,-1,1);
	}
}

//draw pointer on mouse location
if(pointer){
	if(obj_stanncam.gui_hires){
		draw_sprite_ext(spr_arrow,0,room_to_gui_x(pointer_x),room_to_gui_y(pointer_y),1,1,180,-1,1);
	} else {
		draw_sprite_ext(spr_arrow_small,0,room_to_gui_x(pointer_x),room_to_gui_y(pointer_y),1,1,180,-1,1);
	}
}





