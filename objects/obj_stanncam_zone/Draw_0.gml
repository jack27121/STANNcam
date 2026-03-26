if(__obj_stanncam_manager.draw_zones){
	if(active){
		draw_self();
	} else {
		image_alpha = 0.2;
		draw_self();	
		image_alpha = 1;
	}
}
