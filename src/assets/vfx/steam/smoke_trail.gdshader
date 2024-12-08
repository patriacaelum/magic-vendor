shader_type spatial;
#include "res://assets/vfx/billboard.gdshaderinc"

render_mode shadows_disabled, unshaded;

uniform sampler2D gradient_sampler : filter_linear, source_color;
uniform sampler2D smoke_texture : filter_linear, source_color;
uniform sampler2D dissolve_sampler : filter_linear;
uniform float uv_scale : hint_range(0.0, 1.0, 0.1) = 0.5;

varying vec4 custom;
varying vec3 vertex_pos;

void vertex() {
	mat4 billboard_mvm = apply_billboarding(INV_VIEW_MATRIX, MODELVIEW_MATRIX, VIEW_MATRIX, MODEL_MATRIX, INSTANCE_CUSTOM);
	MODELVIEW_MATRIX = billboard_mvm;
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	custom = INSTANCE_CUSTOM;
	// Called for every vertex the material is visible on.
}

void fragment() {
    float circle_grad = distance(vec2(0.5), UV);
	float circle_mask = smoothstep(0.4, 0.2, circle_grad);


    vec3 dissolve_text = texture(dissolve_sampler, UV * uv_scale + custom.z).rgb;
	float dissolve = smoothstep(min(1.5*custom.y+0.1,1.0), 1.0, dissolve_text.r);
    float mask = clamp(circle_mask - (1.0-dissolve), 0.0, 1.0);

   // ALBEDO = vec3(dissolve);
	ALBEDO = texture(gradient_sampler, vec2(dissolve_text.r, 0.0)).rgb;

    ALPHA = mask * COLOR.a;
	//ALPHA_SCISSOR_THRESHOLD = 0.5;

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
