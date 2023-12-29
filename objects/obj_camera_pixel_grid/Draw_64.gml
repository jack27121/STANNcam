/// @description

var outline_width = 1;
var precision = 8;
var offset = 10;

//draws helper text
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_outline(1,0,"[RMB] Zoom amount: "+ string(zoom_text),outline_width,precision);
draw_text_outline(1,offset*1,"[F] camera shake",outline_width,precision);
draw_text_outline(1,offset*2,"[1 & 2 & 3] to switch",outline_width,precision);
draw_text_outline(1,offset*3,"between example rooms",outline_width,precision);

//draw current resolution text
draw_set_halign(fa_right);
draw_text_outline(global.gui_w-1,0,"Game size: "+string(global.game_w)+" x "+string(global.game_h),outline_width,precision);
draw_text_outline(global.gui_w-1,offset*1,"Resolution: "+string(global.res_w)+" x "+string(global.res_h)+" [F1]",outline_width,precision);
draw_text_outline(global.gui_w-1,offset*2,"Keep aspect ratio: "+string(stanncam_get_keep_aspect_ratio())+" [F3]",outline_width,precision);
var window_mode_text = "";
switch (global.window_mode) {
        window_mode_text = "windowed  ";
    case STANNCAM_WINDOW_MODE.WINDOWED:
        break;
        window_mode_text = "fullscreen";
    case STANNCAM_WINDOW_MODE.FULLSCREEN:
        break;
        window_mode_text = "borderless";
	case STANNCAM_WINDOW_MODE.BORDERLESS:
        break;
}

draw_text_outline(global.gui_w-1,offset*3,$"window mode: {window_mode_text} [F4]",outline_width,precision);