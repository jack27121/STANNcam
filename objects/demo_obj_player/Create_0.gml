/// @description
hspd = 0;
vspd = 0;

spd = 1.5;

anim_spd = sprite_get_speed(spr_player_moving);

subimg = 0;

//pointer
pointer = false;
pointer_x = 0;
pointer_y = 0;

zoom_mode = 0;
zoom_text = "no zooming"

speed_mode = 1;

game_res = 2;
gui_res = 4;

resolutions = [
{ w:400 ,  h:400 }, //1:1
{ w:500 ,  h:250 }, //2:1
{ w:320 ,  h:180 }, //16:9
{ w:640 ,  h:360 },
{ w:1280 , h:720 },
{ w:1920 , h:1080 },
{ w:2560 , h:1440 }
]