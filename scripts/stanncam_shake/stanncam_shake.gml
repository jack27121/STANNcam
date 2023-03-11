/// @description makes an object shake
/// @function stanncam_shake
/// @param {Real} time
/// @param {Real} magnitude
/// @param {Real} duration
/// @returns {Real}
function stanncam_shake(t, magnitude, duration) {
	var amount = max(0,(duration-t)/duration);
	return random_range(-magnitude,magnitude) * amount;
}
