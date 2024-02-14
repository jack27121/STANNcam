/// @description
event_inherited();

left	= true;
top		= true;
right	= true;
bottom	= true;

switch (image_angle) {
    case 0:
        left = false;
        break;
    case 90:
        bottom = false;
        break;
	case 180:
        right = false;
        break;
	case 270:
        top = false;
        break;
}
