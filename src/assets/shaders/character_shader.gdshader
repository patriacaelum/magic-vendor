shader_type spatial;

uniform sampler2D albedo_sampler : filter_linear_mipmap, source_color, repeat_disable;

uniform float base_roughness = 1.0;

uniform vec4 emission_color : source_color;
uniform float emission_intensity = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = mix(texture(albedo_sampler, UV).rgb, emission_color.rgb, emission_color.a);
	ROUGHNESS = base_roughness;
	// EMISSION = ALBEDO;
	// EMISSION += emission_color.rgb * emission_intensity;
}
