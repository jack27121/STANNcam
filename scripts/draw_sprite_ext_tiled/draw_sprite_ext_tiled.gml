///@description does draw_sprite_ext tiled x times on the horizontal and vertical axis
///@function draw_sprite_ext_tiled(sprite_,subimg_,x_,y_,tile_h=1,tile_v=1,xscale_=1,yscale_=1,col_=-1,alpha_=1)
function draw_sprite_ext_tiled(sprite_,subimg_,x_,y_,tile_h=1,tile_v=1,xscale_=1,yscale_=1,col_=-1,alpha_=1){
	
	//horizontal
	for (var h = 0; h < tile_h; ++h) {
	    // vertical
		for (var v = 0; v < tile_v; ++v) {
			var x_offset = sprite_get_width(sprite_)*xscale_;
			var y_offset = sprite_get_height(sprite_)*yscale_;
			draw_sprite_ext(sprite_,subimg_,x_+(x_offset*h),y_+(y_offset*v),xscale_,yscale_,0,col_,alpha_);
		}
	}
	
}