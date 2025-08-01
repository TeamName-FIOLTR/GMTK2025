shader_type spatial;
render_mode unshaded;
uniform vec3 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

float remap(float value, float from_start, float from_end, float to_start, float to_end){
    return (value-from_start)*(to_start-to_end)/(from_start-from_end)+to_start;
}


float get_pattern(vec2 uv){
	uv = round(uv*PI*3.0)/(PI*3.0);
	//uint u = ((floatBitsToUint(uv.x)));//<<24u)>>24u);
	//uint v = ((floatBitsToUint(uv.y)));//<<24u)>>24u);
	//
	//uint thing = u ^ v;
	//
	//float new_thing = float((thing>>18u)%2u);
	float r1 = cos(38743.0*uv.x*sqrt(2.0));
	float r2 = sin(21722.0*uv.y*sqrt(3.0));
	return r1*r2;
}

float get_thing_ig(vec3 pos){
	float angle_thing = fract(remap(atan(pos.y,pos.x),-PI,PI,0,1)+TIME/3.0);
	vec2 uv_thing = vec2(angle_thing,sqrt(5.0)+pos.z/4.0);
	float output_thing = 0.0;
	for(int i = -3; i <= 3; i++){
		output_thing += get_pattern(uv_thing+vec2(float(i)+sqrt(3.0),float(i+3)*1.1)*PI*10.0);
	}
	return output_thing*float(pos.z < 0.49 && pos.z > -0.49);
}

void fragment() {
	vec3 pos = (inverse(MODEL_MATRIX)*INV_VIEW_MATRIX*vec4(VERTEX,1.0)).xyz;
	vec3 pos2 = vec3(pos.x,-pos.z,pos.y);
	vec3 pos3 = vec3(pos.y,pos.z,-pos.x);
	//vec3 pos2 = pos.
	float thing0 = get_thing_ig(pos);
	float thing1 = get_thing_ig(pos2);
	float thing2 = get_thing_ig(pos3);

	//ALBEDO = vec3(thing0);
	//ALBEDO = vec3(thing1);
	//ALBEDO = vec3(thing2);

	ALBEDO = color*max(0.0,thing0+thing1+thing2);
	//ALBEDO = vec3(thing0+thing1+thing2);
	//ALBEDO = vec3(get_thing_ig(pos)+get_thing_ig(pos2)+get_thing_ig(pos3));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
