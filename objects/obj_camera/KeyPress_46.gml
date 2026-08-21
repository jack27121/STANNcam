//delete camera zone
count = 0;
with(obj_stanncam_zone){
	if (other.count == 0) instance_destroy(self)	
	other.count++;
}
