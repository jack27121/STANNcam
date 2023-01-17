/// @description
if (!is_undefined(global.camera_follow)){
	//update destination
	xTo = global.camera_follow.x;
	yTo = global.camera_follow.y;
	
	//update camera position
	while (abs(xTo - x) > bounds_w)
	{
		if (x < xTo) x+=spd;
		else if (x > xTo) x-=spd;
	}
	
	while (abs(y - yTo) > bounds_h)
	{
		if (y < yTo) y+=spd;
		else if (y > yTo) y-=spd;
	}
} else if(moving){
	//gradually moves camera into position based on duration
	x = ease_in_out(t,xStart,xTo-xStart,duration);
	y = ease_in_out(t,yStart,yTo-yStart,duration);

	t++;
	if(x == xTo && y == yTo) moving = false;
}

#region screen-shake
var stanncam_shake_ = shake(shake_time++,shake_magnitude,shake_length);
shake_x = stanncam_shake_;
shake_y = stanncam_shake_;
var vibration = stanncam_shake_ / 20;
gamepad_set_vibration(0,vibration,vibration);
#endregion

#region constrains camera to room bounds
if(camera_constrain){
	x = clamp(x,(global.view_w/2),room_width -(global.view_w/2));
	y = clamp(y,(global.view_h/2),room_height-(global.view_h/2));
}
#endregion

#region zooming
if(zooming){
	//gradually zooms camera
	zoom = ease_in_out(t_zoom,zoomStart,zoomTo-zoomStart,zoom_duration);
	t_zoom++;
	if(zoom == zoomTo) zooming = false;
	camera_set_view_size(cam,global.view_w*zoom,global.view_h*zoom);
	zoom_x = ((global.view_w*zoom) - global.view_w)/2;
	zoom_y = ((global.view_h*zoom) - global.view_h)/2;
}
#endregion

//update camera view
var new_x = x - (global.view_w / 2 + shake_x + zoom_x);
var new_y = y - (global.view_h / 2 + shake_y + zoom_y);

camera_set_view_pos(cam, new_x, new_y);
