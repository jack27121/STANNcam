/// @description
stanncam_init(320,240,1920,1080);
cam1 = new stanncam(demo_obj_player.x,demo_obj_player.y,320,240);

cam1.follow = demo_obj_player;

cam2 = new stanncam(demo_obj_player2.x,demo_obj_player2.y,320,240);

cam2.follow = demo_obj_player2;