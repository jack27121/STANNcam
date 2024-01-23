/// @description which sides to constrain
left	= true;
top		= true;
right	= true;
bottom	= true;

if(image_angle mod 90 != 0){
	show_error($"stanncam_camzone {id}/bimage_angle must be 90 degree angles",true);
}

if(image_angle < 0) image_angle += 360;
if(image_angle > 360) image_angle -= 360;



















