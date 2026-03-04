view_enabled = true;
var _len = array_length(global.stanncams);
for (var i = 0; i < _len; ++i){
	var _cam = global.stanncams[i];
	if(_cam == -1) continue;
	_cam.__check_viewports();
	_cam.__step();
	
	//if following something, snap the camera to it on room start
	if(STANNCAM_CONFIG_SNAP_TO_FOLLOW_ON_ROOM_START && instance_exists(_cam.follow)){
		_cam.move(_cam.follow.x, _cam.follow.y, 0);
		
		if(STANNCAM_CONFIG_SNAP_TO_ZONE_ON_ROOM_START){
			var _list_strength_length = array_length(_cam.__zone_lists_strength);
			if (_list_strength_length > 0){
				_cam.__zone_lists_strength[_list_strength_length-1] = 1;
			}
		}
		
	}
}

__stanncam_update_resolution();
