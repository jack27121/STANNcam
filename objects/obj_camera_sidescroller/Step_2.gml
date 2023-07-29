/// @description

//fancy split screen
//x = lerp(obj_player_sidescroller.x,obj_player_sidescroller2.x,0.5);
//y = lerp(obj_player_sidescroller.y,obj_player_sidescroller2.y,0.5);
//player_dist = point_distance(obj_player_sidescroller.x,obj_player_sidescroller.y,obj_player_sidescroller2.x,obj_player_sidescroller2.y);

//when the players are close together the camera follows the middle point between them
//if(split_screen){
//	if(player_dist > 100){
//		cam1.follow = obj_player_sidescroller;	
//		cam2.follow = obj_player_sidescroller2;
//	} else {
//		cam1.follow = self;
//		cam2.follow = self;
//	}
//}