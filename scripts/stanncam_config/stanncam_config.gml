///STANNcam config macros, to change certain global behavior for all cameras

#macro STANNCAM_CONFIG_SNAP_TO_FOLLOW_ON_ROOM_START true //Default: true //if a followed object is active at the start of a room, should the camera be snapped to it?
#macro STANNCAM_CONFIG_SNAP_TO_ZONE_ON_ROOM_START true   //Default: true //if a followed object is within a constrain zone at start of room, should thee camera be snapped to it?

#macro STANNCAM_CONFIG_ZONE_CONSTRAIN_ALWAYS_SMOOTH false //Default: false //if true, the transition will be smooth regardless of smooth_draw

#macro STANNCAM_CONFIG_ZONE_CONSTRAIN_TRANSITION_SNAP_THRESHOLD 0.003 //Default 0.003 //with smooth_draw off, transitioning between zones, it will snap when over this threshold

#macro STANNCAM_CONFIG_DRAW_CAMERA_ZONES __obj_stanncam_manager.draw_zones //Default: __obj_stanncam_manager.draw_zones //set to whichever global variable you like to easily control if zones should be drawn