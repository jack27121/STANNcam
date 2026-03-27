if(STANNCAM_CONFIG_DRAW_CAMERA_ZONES){
	if(active){
		draw_self();
	} else {
		image_alpha = 0.2;
		draw_self();	
		image_alpha = 1;
	}
}
