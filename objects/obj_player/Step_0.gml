/// @description
hspd = (keyboard_check_direct(vk_right) - keyboard_check_direct(vk_left)) * spd;
vspd = (keyboard_check_direct(vk_down) - keyboard_check_direct(vk_up)) * spd;

x+= hspd;
y+= vspd;

x = clamp(x,0,room_width);
y = clamp(y,0,room_height);