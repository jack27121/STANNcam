function draw_text_outline(x_,y_,text,width = 1, precision = 16,col = c_black){
	
	var prev_color = draw_get_color();
	draw_set_color(col);
	
	var rot = 360 / precision;
	
	if(precision > 8){
		for (var i = 0; i < precision; ++i) {
			var t_x = x_ + lengthdir_x(width,rot*i)
			var t_y = y_ + lengthdir_y(width,rot*i)
		    draw_text(t_x,t_y,text);
		}
	} else {
		for (var i = 0; i < precision; ++i) {
			var t_x = x_ + sign(lengthdir_x(width,rot*i));
			var t_y = y_ + sign(lengthdir_y(width,rot*i));
		    draw_text(t_x,t_y,text);
		}
	}
	
	draw_set_color(prev_color);
	draw_text(x_,y_,text);
}