hinput = right() - left();

//horizontal movement
if(hinput != 0){
	image_xscale = sign(hinput);
	hspd = clamp(hspd + acc * hinput, -top_spd, top_spd);
} else if(hspd != 0){
	hspd -= acc * sign(hspd);
	if(abs(hspd) < acc) hspd = 0;
}

//vertical movement
if(jump() && jump_count < jump_max){
	vspd = -8;
	scale_x = 0.4;
	scale_y = 1.6;
	jump_count++;
}
vspd += acc;
vspd = clamp(vspd, -20, 20);

//collisions
//horizontal
if(place_meeting(x + hspd, y, obj_collision)){
	var _hspd = hspd;
	while(abs(_hspd) > 0.1){
		_hspd *= 0.5;
		if(!place_meeting(x + _hspd, y, obj_collision)) x += _hspd;
	}
	hspd = 0;
}
x += hspd;

//vertical
if(place_meeting(x, y + vspd, obj_collision)){
	var _vspd = vspd;
	if(vspd > 0 && !grounded){
		grounded = true;
		jump_count = 0;
		scale_x = 1.6;
		scale_y = 0.4;
	}
	while(abs(_vspd) > 0.1){
		_vspd *= 0.5;
		if(!place_meeting(x, y + _vspd, obj_collision)) y += _vspd;
	}
	if(abs(vspd) < 1) vspd = 0;
	vspd = 0;
} else {
	grounded = false;
}
y += vspd;

scale_x = lerp(scale_x, 1, 0.15);
scale_y = lerp(scale_y, 1, 0.15);
