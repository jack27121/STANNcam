/// @description
hinput = right() - left();

//horizontal movement
if(hinput != 0){
	image_xscale = sign(hinput);
	hspd+=acc*hinput;
	hspd = clamp(hspd,-top_spd,top_spd);
} else if(hspd != 0){	
	hspd-= acc*sign(hspd);
	if(abs(hspd) < acc) hspd = 0;
}

//vertical movement
if(jump() && jump_count < jump_max){
	vspd=-8;
	scale_x = 0.4;	
	scale_y = 1.6;
	jump_count++;
}
vspd+=acc
vspd = clamp(vspd,-20,20);

//collissions
//horizontal
if(place_meeting(x + hspd, y, obj_collision)){
	var hspd_ = hspd;
	while( abs(hspd_) > 0.1){
		hspd_ *=0.5;
		if (!place_meeting(x+hspd_,y,obj_collision)) x+=hspd_;
	}
	hspd = 0;
}
x+= hspd;

//vertical
if(place_meeting(x, y+vspd, obj_collision)){
	var vspd_ = vspd;
	if(vspd > 0 && !grounded){
		grounded = true;
		jump_count = 0;	
		scale_x = 1.6;
		scale_y = 0.4;	
		
	}
	while( abs(vspd_) > 0.1){
		vspd_ *=0.5;
		if (!place_meeting(x,y+vspd_,obj_collision)) y+=vspd_;
	}
	if(abs(vspd) < 1) vspd = 0; 
	vspd = 0;
}
else grounded = false;
y+= vspd;

scale_x = lerp(scale_x,1,0.15);
scale_y = lerp(scale_y,1,0.15);
