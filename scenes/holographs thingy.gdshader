shader_type spatial;
uniform sampler2D holograph_scrren :source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(0.0);
	vec2 cool_uv = round(UV*10.0)/10.0;
	float n = 30.0;
	vec2 randyyy = vec2(max(round(pow(cos(cool_uv.x*sqrt(5.0)*347683.0),3.0)*n)/n,0.0));
	vec2 glitch = sin(cool_uv*sqrt(5.0)*30.0+10.0*sqrt(2.0)*(round(TIME+round(mix(1.0,3.0,UV.y))*sin(2.0*PI*TIME/5.0)*10.0)/10.0));
	EMISSION = 3.0*texture(holograph_scrren,UV+glitch*randyyy).rgb;
	//EMISSION = vec3(randyyy.x);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
