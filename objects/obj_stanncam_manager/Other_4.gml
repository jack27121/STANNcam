/// @description
view_enabled = true;
for (var i = 0; i < array_length(global.stanncams); ++i) {  
	global.stanncams[i].check_viewports();
}
stanncam_update_resolution();