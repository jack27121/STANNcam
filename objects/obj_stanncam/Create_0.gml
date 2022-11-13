/// @description
#macro cam view_camera[0]

#region change these global variables to whatever you need.
//if you change resolution or scale at runtime, run resolution_update() after
global.view_w = 320; //game resolution width
global.view_h = 180; //game resolution height
global.gui_w = 1280;  //gui  resolution width
global.gui_h = 720;  //gui  resolution height
global.upscale = 4; //how much the game should be upscaled

global.camera_follow = undefined; //what object the camera should follow
spd = 0.2; //how fast the camera follows an object
gui_hires = true; //if the gui should be independant of the game resolution
camera_constrain = false; //if camera should be constrained to the room size
//the camera bounding box, for the followed object to leave before the camera starts moving
bounds_w = 20;
bounds_h = 20;

resolution_update();
#endregion

#region inits neccesary variables
//zoom
zoom = 1;
zoom_x = 0;
zoom_y = 0;
zooming = false;

//screen shake
shake_length = 0;
shake_magnitude = 0;
shake_time = 0;
shake_x = 0;
shake_y = 0;

moving = false;
#endregion

application_surface_draw_enable(false);