shader_type spatial;
render_mode unshaded;
render_mode blend_add;
render_mode cull_disabled;
uniform bool locked;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float thing = 0.01;
	ALBEDO = 3.0*(locked?vec3(1,thing,thing):vec3(0,1,0));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
