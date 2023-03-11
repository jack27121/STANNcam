/// @function stanncam_ease_in_out
/// @param {Real} t - time
/// @param {Real} b - start
/// @param {Real} c - change
/// @param {Real} d - duration
/// @returns {Real}
function stanncam_ease_in_out(t, b, c, d) {
	t /= d/2;
	if (t < 1) return c/2*t*t +b;
	t--;
	return -c/2 * (t * (t-2) -1) + b;
}
