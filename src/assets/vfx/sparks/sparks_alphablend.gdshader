shader_type spatial;
render_mode shadows_disabled, unshaded;

uniform sampler2D texture_sample : filter_linear;
varying vec4 custom;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void vertex() {
    custom = INSTANCE_CUSTOM;
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec3 mask = texture(texture_sample, UV).rgb;


    ALBEDO = vec3(COLOR.r * (1.0 - custom.y) * 50.0, COLOR.g, COLOR.b);
    ALPHA = COLOR.a * mask.r;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
