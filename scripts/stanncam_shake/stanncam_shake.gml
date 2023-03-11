/// @description makes an object shake
/// @function stanncam_shake
/// @param {Real} time
/// @param {Real} magnitude
/// @param {Real} duration
/// @returns {Real}
function stanncam_shake(time, magnitude, duration) {
	var amount = max(0,(duration-time)/duration);
	return random_range(-magnitude,magnitude) * amount;
}
