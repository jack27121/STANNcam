room_goto_next();

//Debug overlay
show_debug_overlay(true,true,2)

dbgview = dbg_view("settings",true);
section = dbg_section("Stanncam manager");

#region Change screen resolution
resolution = global.stanncam_res[STANNCAM_RES.DESKTOP_1080P];

var _ref = ref_create(self,"resolution");

var screen_resolutions = stanncam_get_resolution_array(STANNCAM_RES.DESKTOP_720P,STANNCAM_RES.DESKTOP_4K);
dbg_drop_down(_ref,screen_resolutions);

dbg_same_line();
dbg_button("apply resolution",function(){
	stanncam_set_resolution(resolution.width,resolution.height);
})
#endregion

#region Change GUI resolution
gui_resolution = global.stanncam_res[STANNCAM_RES.DESKTOP_1080P];

_ref = ref_create(self,"gui_resolution");

var gui_resolutions = stanncam_get_resolution_array();
dbg_drop_down(_ref,gui_resolutions);

dbg_same_line();
dbg_button("apply GUI resolution",function(){
	stanncam_set_gui_resolution(gui_resolution.width,gui_resolution.height);
})
#endregion

//switch gui resolutions
if(keyboard_check_pressed(vk_f2)){
	gui_res++
	if(gui_res > 6) gui_res = 0;
	var _gui_w = resolutions[gui_res].w;
	var _gui_h = resolutions[gui_res].h;
	stanncam_set_gui_resolution(_gui_w, _gui_h);
}

//toggle keep aspect ratio
if(keyboard_check_pressed(vk_f3)){
	stanncam_set_keep_aspect_ratio(!stanncam_get_keep_aspect_ratio());
}

//toggle between window modes
if(keyboard_check_pressed(vk_f4)){
	var _window_mode = global.window_mode;
	_window_mode++;
	if(_window_mode == 3) _window_mode = 0;
	
	stanncam_set_window_mode(_window_mode);
}
