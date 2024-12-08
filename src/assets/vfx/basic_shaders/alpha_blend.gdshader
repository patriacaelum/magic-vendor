shader_type spatial;

render_mode unshaded, shadows_disabled;

uniform sampler2D mask_texture : filter_linear;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 mask = texture(mask_texture, UV);
    ALBEDO = COLOR.rgb;
    ALPHA = mask.r;


	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
