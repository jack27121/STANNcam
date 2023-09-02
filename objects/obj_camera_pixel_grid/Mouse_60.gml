/// @description
var zoom_amount = cam1.zoom_amount;
zoom_amount-=0.05
zoom_amount = clamp(zoom_amount,0.1,2);
cam1.zoom(zoom_amount,0);