resolution = global.stanncam_res_presets[STANNCAM_RES_PRESETS.DESKTOP_1080P];

stanncam_init(320, 180, resolution.width, resolution.height);

#region Debug overlay
//dbg_add_font_glyphs("text.ttf",14,5);
show_debug_overlay(true,true,1)

dbgview = dbg_view("settings",true);

section = dbg_section("Stanncam manager");
#region Change screen resolution

var _ref = ref_create(self,"resolution");

screen_resolutions = stanncam_get_preset_resolution_range(STANNCAM_RES_PRESETS.DESKTOP_720P,STANNCAM_RES_PRESETS.DESKTOP_4K);
//inserting an extra 1:1 resolution that isn't part of any preset, you can define and use any resolutions you'd like
array_insert(screen_resolutions,0,{width: 600, height: 600});

dbg_drop_down(_ref,screen_resolutions);

dbg_same_line();
dbg_button("apply resolution",function(){
	stanncam_set_resolution(resolution.width,resolution.height);
})
#endregion

#region Change GUI resolution
gui_resolution = global.stanncam_res_presets[STANNCAM_RES_PRESETS.DESKTOP_1080P];

_ref = ref_create(self,"gui_resolution");

gui_resolutions = stanncam_get_preset_resolution_range(); //no params defaults to getting all presets
dbg_drop_down(_ref,gui_resolutions);

dbg_same_line();
dbg_button("apply GUI resolution",function(){
	stanncam_set_gui_resolution(gui_resolution.width,gui_resolution.height);
})
#endregion

#region Toggle keep aspect ratio

keep_aspect_ratio = stanncam_get_keep_aspect_ratio();
_ref = ref_create(self,"keep_aspect_ratio");

dbg_text("Keep aspect ratio:");
dbg_same_line()
dbg_text(_ref);
dbg_same_line()
dbg_button("Toggle",function(){
	//toggles to keep aspect ratio
	keep_aspect_ratio  = !stanncam_get_keep_aspect_ratio();
	stanncam_set_keep_aspect_ratio(keep_aspect_ratio);
})
#endregion

#region set window mode

dbg_button("windowed",function(){
	stanncam_set_windowed()
});
dbg_same_line()
dbg_button("fullscreen",function(){
	stanncam_set_fullscreen()
});
dbg_same_line()
dbg_button("borderless fullscreen",function(){
	stanncam_set_borderless()
});
#endregion
section = dbg_section("Switch between example rooms");
dbg_button("Topdown",function(){
	room_goto(rm_test);
})
dbg_same_line();
dbg_button("Sidescroller",function(){
	room_goto(rm_sidescroller);
})
dbg_same_line();
dbg_button("Pixel-grid",function(){
	room_goto(rm_pixel_grid);
})



#endregion

room_goto_next();