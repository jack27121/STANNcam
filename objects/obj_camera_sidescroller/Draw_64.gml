/// @description
//chooses pixel font or hires font
if(gui_hires){
	draw_set_font(f_hires);
	var offset = 45;
	var outline_width = 4;
	var precision = 16;
	draw_set_color(c_white)
} else {
  draw_set_font(f_pixel);
  var offset = 8;
  var outline_width = 1;
  var precision = 8;
  draw_set_color(c_white)
}

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1,1,"[arrow keys] move character",outline_width,precision);
draw_text_outline(1,offset*2,"[ALT] toggle hi-res GUI",outline_width,precision);
draw_text_outline(1,offset*4,"[RMB] / [SCRL WHEEL] "+ string(zoom_text),outline_width,precision);
var constrained = (cam1.room_constrain) ? "camera constrained to room" : "camera not constrained to room";
draw_text_outline(1,offset*5,"[CTRL] "+ constrained,outline_width,precision);
var debug = (cam1.debug_draw) ? "debug draw on" : "debug draw off";
draw_text_outline(1,offset*6,"[SHIFT] "+ debug,outline_width,precision);
draw_text_outline(1,offset*7,"[F] camera shake",outline_width,precision);
draw_text_outline(1,offset*8,"[Tab] camera speed "+ string(cam1.spd),outline_width,precision);
draw_text_outline(1,offset*9,"[1 & 2] to switch between example rooms",outline_width,precision);

//draw current resolution text
draw_set_halign(fa_right)
draw_text_outline(global.gui_w-1,1,"game resolution: "+string(global.res_w)+" x "+string(global.res_h)+" [F1]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset,"GUI resolution: "+string(global.gui_w)+" x "+string(global.gui_h)+" [F2]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*2,"Keep aspect ratio: "+string(stanncam_get_keep_aspect_ratio())+" [F3]",outline_width,precision);

var window_mode_text = "";
switch (global.window_mode) {
    case STANNCAM_WINDOW_MODE.windowed:
        window_mode_text = "windowed  ";
        break;
    case STANNCAM_WINDOW_MODE.fullscreen:
        window_mode_text = "fullscreen";
        break;
	case STANNCAM_WINDOW_MODE.borderless:
        window_mode_text = "borderless";
        break;
}

draw_text_outline(global.gui_w-1,offset*3,$"window mode: {window_mode_text} [F4]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*4,"split-screen: "+string(split_screen)+" [F5]",outline_width,precision);