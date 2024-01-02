/// @function draw_text_outline
/// @param {Real} _x
/// @param {Real} _y
/// @param {String} _text
/// @param {Real} [_width=1]
/// @param {Real} [_precision=16]
/// @param {Constant.Color} [_col=c_black]
function draw_text_outline(_x, _y, _text, _width=1, _precision=16, _col=c_black){
	
	var _prev_color = draw_get_color();
	draw_set_color(_col);
	
	var _rot = 360 / _precision;
	
	if(_precision > 8){
		for (var i = 0; i < _precision; ++i){
			var _t_x = _x + lengthdir_x(_width, _rot * i);
			var _t_y = _y + lengthdir_y(_width, _rot * i);
			draw_text(_t_x, _t_y, _text);
		}
	} else {
		for (var i = 0; i < _precision; ++i){
			var _t_x = _x + sign(lengthdir_x(_width, _rot * i));
			var _t_y = _y + sign(lengthdir_y(_width, _rot * i));
			draw_text(_t_x, _t_y, _text);
		}
	}
	
	draw_set_color(_prev_color);
	draw_text(_x, _y, _text);
}
