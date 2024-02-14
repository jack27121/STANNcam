/// @description
event_inherited();

left	= false;
top		= false;
right	= false;
bottom	= false;

switch (image_angle) {
    case 0:
        right = true;
		left = true;
        break;
    case 90:
        top = true;
		bottom = true;
        break;
	case 180:
        right = true;
		left = true;
        break;
	case 270:
        top = true;
		bottom = true;
        break;
}
