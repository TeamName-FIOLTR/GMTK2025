shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 new_color = 1.0-texture(screen,SCREEN_UV);
	new_color.a = 1.0;
	COLOR = new_color;
	//float thing = min(abs(1.0-2.0*UV.y),abs(1.0-2.0*UV.x));
	//bool crosshair = thing<0.1;
	//COLOR = crosshair?new_color:texture(screen,SCREEN_UV);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
