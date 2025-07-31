shader_type spatial;
uniform sampler2D textureee : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//EMISSION = texture()
	vec3 color = texture(textureee,UV).rgb;
	float bright = pow(dot(color,vec3(1.0)),3.0);
	EMISSION = color*bright;
	ALBEDO = texture(textureee,UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
