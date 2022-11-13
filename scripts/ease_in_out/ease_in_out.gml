/// @function ease_in_out(time, start, change, duration)
function ease_in_out(t, b, c, d) {
	t /= d/2;
	if (t < 1) return c/2*t*t +b;
	t--;
	return -c/2 * (t * (t-2) -1) + b;
}