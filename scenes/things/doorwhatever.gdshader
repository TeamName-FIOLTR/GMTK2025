shader_type spatial;

render_mode blend_add;
render_mode cull_disabled;
render_mode unshaded;
uniform vec2 size;
uniform bool locked;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 pos = (INV_VIEW_MATRIX*vec4(VERTEX,1.0)).xyz;
	float thing = pow((1.0+cos((pos.y*10.0-TIME*2.0)*2.0*PI/1.0))/2.0,locked?1.0:(1.0+(1.0-abs(1.0-2.0*UV.x))*30.0));
	float boarder_x = (1.0-abs(1.0-2.0*UV.x))*size.x;
	float boarder_y = (1.0-abs(1.0-2.0*UV.y))*size.y;
	bool boarder = (locked?min(boarder_x,boarder_y):boarder_x)<0.1;
	//if(!locked){boarder = boarder_x<0.1;}
	vec3 color = locked?vec3(1,0,0):vec3(0,1,0);
	//ALBEDO = vec3(0);
	vec3 final_color = color*(boarder?1.0:(locked?thing:(thing*max(mix(-1.0,0.5,abs(1.0-2.0*UV.x)),0.0)))); // screq it, nested tertiaries
	ALBEDO = final_color;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
