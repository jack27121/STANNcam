/// @function draw_sprite_ext_tiled
/// @description does draw_sprite_ext tiled x times on the horizontal and vertical axis
/// @param {Asset.GMSprite} _sprite
/// @param {Real} _subimg
/// @param {Real} _x
/// @param {Real} _y
/// @param {Real} [_tile_h=1]
/// @param {Real} [_tile_v=1]
/// @param {Real} [_xscale=1]
/// @param {Real} [_yscale=1]
/// @param {Real} [_col=-1]
/// @param {Real} [_alpha=1]
function draw_sprite_ext_tiled(_sprite, _subimg, _x, _y, _tile_h=1, _tile_v=1, _xscale=1, _yscale=1, _col=-1, _alpha=1){
	//horizontal
	for (var h = 0; h < _tile_h; ++h){
		// vertical
		for (var v = 0; v < _tile_v; ++v){
			var _x_offset = sprite_get_width(_sprite) * _xscale;
			var _y_offset = sprite_get_height(_sprite) * _yscale;
			draw_sprite_ext(_sprite, _subimg, _x + (_x_offset * h), _y + (_y_offset * v), _xscale, _yscale, 0, _col, _alpha);
		}
	}
}
