/// @description
for (var i = 0; i < array_length(global.stanncams); ++i) {  
	if (global.stanncams[i] == -1) continue;
	global.stanncams[i].__predraw();
}