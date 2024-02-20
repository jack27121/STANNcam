/// @description which sides to constrain
left = true;
top = true;
right = true;
bottom = true;

image_angle = (image_angle mod 360 + 360) mod 360;

if(image_angle mod 90 != 0){
	show_error(object_get_name(object_index) + ".image_angle must be a multiple of 90 degrees, got " + string(image_angle) + ".", true);
}
