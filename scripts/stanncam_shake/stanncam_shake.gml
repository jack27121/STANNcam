/// @function stanncam_shake
/// @description makes an object shake
/// @param {Real} _time
/// @param {Real} _magnitude
/// @param {Real} _duration
/// @returns {Real}
function stanncam_shake(_time, _magnitude, _duration){
	var _amount = max(0, (_duration - _time) / _duration);
	return random_range(-_magnitude, _magnitude) * _amount;
}
