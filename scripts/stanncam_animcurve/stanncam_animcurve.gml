/// @function stanncam_animcurve
/// @param {Real} _t - time
/// @param {Real} _start
/// @param {Real} _finish
/// @param {Real} _dur - duration in frames
/// @param {Real} _anim_curve - animation curve index
/// @returns {Real}
function stanncam_animcurve(_t,_start,_finish,_dur,_anim_curve = stanncam_ac_ease){
	
	if(_dur == 0){
		return _finish;	
	}
	
	var _channel = animcurve_get_channel(_anim_curve, 0);
	var _val = animcurve_channel_evaluate(_channel, (_t/_dur));
	return lerp(_start,_finish,_val);
}