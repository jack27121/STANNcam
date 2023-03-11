/// @description
//chooses pixel font or hires font
if(gui_hires){
	draw_set_font(demo_f_hires);
	var offset = 45;
	var outline_width = 4;
	var precision = 16;
	draw_set_color(c_white)
} else {
  draw_set_font(demo_f_pixel);
  var offset = 8;
  var outline_width = 1;
  var precision = 8;
  draw_set_color(c_white)
}

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1,1,"[arrow keys] move character",outline_width,precision);
var following = (cam1.follow != undefined) ? "following" : "not following"
draw_text_outline(1,offset,"[space] " + following,outline_width,precision);
draw_text_outline(1,offset*2,"[ALT] toggle hi-res GUI",outline_width,precision);
draw_text_outline(1,offset*3,"[LMB] move cam to pos (when not following)",outline_width,precision);
draw_text_outline(1,offset*4,"[RMB] "+ zoom_text,outline_width,precision);
var constrained = (cam1.room_constrain) ? "camera constrained to room" : "camera not constrained to room";
draw_text_outline(1,offset*5,"[CTRL] "+ constrained,outline_width,precision);
draw_text_outline(1,offset*6,"[F] camera shake",outline_width,precision);
draw_text_outline(1,offset*7,"[Tab] camera speed "+ string(cam1.spd),outline_width,precision);

//draw current resolution text
draw_set_halign(fa_right)
draw_text_outline(global.gui_w-1,1,"game resolution: "+string(__obj_stanncam_manager.display_res_w)+" x "+string(__obj_stanncam_manager.display_res_h)+" [F1]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset,"GUI resolution: "+string(global.gui_w)+" x "+string(global.gui_h)+" [F2]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*2,"Keep aspect ratio: "+string(stanncam_get_keep_aspect_ratio())+" [F3]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*3,"fullscreen: "+string(window_get_fullscreen())+" [F4]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*4,"split-screen: "+string(split_screen)+" [F5]",outline_width,precision);

//point at player, when it's outside camera bounds
if(cam1.out_of_bounds(demo_obj_player.x,demo_obj_player.y,8)){
	var _x = cam1.room_to_gui_x(demo_obj_player.x);
	var _y = cam1.room_to_gui_y(demo_obj_player.y);
	
	var margin = (gui_hires) ? 50 : 20;
	
	var gui_scale_x = stanncam_get_gui_scale_x();
	var gui_scale_y = stanncam_get_gui_scale_y();
	
	_x = clamp(_x,margin,cam1.width  * gui_scale_x -margin);
	_y = clamp(_y,margin,cam1.height * gui_scale_y -margin);
	
	var dir = point_direction(_x,_y,cam1.room_to_gui_x(demo_obj_player.x),cam1.room_to_gui_y(demo_obj_player.y));

	if(gui_hires){
		draw_sprite_ext(spr_arrow,0,_x,_y,1,1,dir-90,-1,1);
	}else{
		draw_sprite_ext(spr_arrow_small,0,_x,_y,1,1,dir-90,-1,1);
	}
} else {
	//draws pointer over players head
	var arrow_x = cam1.room_to_gui_x(demo_obj_player.x);
	var arrow_y = cam1.room_to_gui_y(demo_obj_player.y);
	if(gui_hires){
		draw_sprite_ext(spr_arrow,1,arrow_x,arrow_y-64,0.5,0.5,180,-1,1);
	} else {
		draw_sprite_ext(spr_arrow_small,1,arrow_x,arrow_y-12,1,1,180,-1,1);
	}
}

//draw pointer on mouse location
if(pointer){
	var arrow_x = cam1.room_to_gui_x( pointer_x );
	var arrow_y = cam1.room_to_gui_y( pointer_y );
	if(gui_hires){
		draw_sprite_ext(spr_arrow,0,arrow_x,arrow_y,1,1,180,-1,1);
	} else {
		draw_sprite_ext(spr_arrow_small,0,arrow_x,arrow_y,1,1,180,-1,1);
	}
}