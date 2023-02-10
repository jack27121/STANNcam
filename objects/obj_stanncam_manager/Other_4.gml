/// @description
view_enabled = true;
for (var i = 0; i < array_length(global.stanncams); ++i) {  
	if (global.stanncams[i] == -1) continue;
	global.stanncams[i].__check_viewports();
}
__stanncam_update_resolution();
