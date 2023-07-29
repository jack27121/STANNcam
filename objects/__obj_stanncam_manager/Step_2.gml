for (var i = 0; i < array_length(global.stanncams); ++i) {
	if (global.stanncams[i] == -1) continue;
	global.stanncams[i].__step();
}

//constantly checks if the window is being resized and changes the resolution to match
if(global.window_mode == STANNCAM_WINDOW_MODE.windowed && (resize_width != window_get_width() || resize_height != window_get_height())){
	resize_width =  window_get_width();
	resize_height = window_get_height();
	stanncam_set_resolution(resize_width,resize_height);
}