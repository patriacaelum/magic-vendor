shader_type spatial;
render_mode blend_mix, cull_front, unshaded;

uniform vec4 color : source_color = vec4(1.74, 0.98, 0, 1);
uniform float inflate_amount : hint_range(0.0, .2, 0.01 ) = 0.03;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += NORMAL * inflate_amount;
}

void fragment() {
	ALBEDO = color.rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
