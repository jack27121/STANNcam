/// @description
event_inherited();

left	= false;
top		= false;
right	= false;
bottom	= false;

switch (image_angle) {
    case 0:
        right = true;
        break;
    case 90:
        top = true;
        break;
	case 180:
        left = true;
        break;
	case 270:
        bottom = true;
        break;
}
