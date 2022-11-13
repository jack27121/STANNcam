/// @function shake(time, magnitude, duration);
/// @param	time
/// @param	magnitude
/// @param	duration in frames
/// @description makes an object shake
function shake() {
	var t = argument[0]; // time
	var shake_magnitude = argument[1];
	var shake_length = argument[2];

	var amount = max(0,(shake_length-t)/shake_length)
	return random_range(-shake_magnitude,shake_magnitude) * amount;
}
