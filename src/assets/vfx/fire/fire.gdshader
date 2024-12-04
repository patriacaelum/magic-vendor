shader_type spatial;

#include "res://assets/vfx/billboard.gdshaderinc"

render_mode shadows_disabled, unshaded;

uniform sampler2D gradient_sampler : filter_linear, source_color, repeat_disable;
uniform sampler2D noise_sampler : filter_linear, repeat_disable;
uniform float uv_scale : hint_range(0.0, 1.0, 0.1) = 0.5;

varying vec4 custom;

void vertex() {
    mat4 billboard_mvm = apply_billboarding(INV_VIEW_MATRIX, MODELVIEW_MATRIX, VIEW_MATRIX, MODEL_MATRIX, INSTANCE_CUSTOM);
    MODELVIEW_MATRIX = billboard_mvm;
    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
    custom = INSTANCE_CUSTOM;
}

void fragment() {
	// Called for every pixel the material is visible on.
    float mask = texture(noise_sampler, UV * uv_scale).x;
    ALBEDO = vec3(mask);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
