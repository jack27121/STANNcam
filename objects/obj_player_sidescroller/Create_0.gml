//player
hinput = 0;

hspd = 0;
vspd = 0;
acc = 0.4;
top_spd = 6;

grounded = false;
jump_count = 0;
jump_max = 2;

scale_x = 1;
scale_y = 1;

lookahead = false;

left = function(){
	return keyboard_check_direct(vk_left);
};
right = function(){
	return keyboard_check_direct(vk_right);
};
jump = function(){
	return keyboard_check_pressed(vk_up);
};
