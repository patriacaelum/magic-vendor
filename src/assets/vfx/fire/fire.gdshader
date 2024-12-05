shader_type spatial;

#include "res://assets/vfx/billboard.gdshaderinc"

render_mode shadows_disabled, unshaded;

uniform sampler2D gradient_sampler : filter_linear, source_color, repeat_disable;
uniform sampler2D noise_sampler : filter_linear;
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
    // INSTANCE_CUSTOM.z is the animation frame, controllable in ParticleProcessMaterial
    // INSTANCE_CUSTOM.y is the 0-1 lifetime
    float mask = texture(noise_sampler, UV * uv_scale + custom.z).x - 0.5 + custom.y;

    // Create a circular gradient
    float circle_grad = distance(UV, vec2(0.5));
    float circle_mask = smoothstep(0.45, 0.1, circle_grad);

    vec3 gradient = texture(gradient_sampler, vec2(mask, 0.0)).rgb;
    ALBEDO = vec3(gradient);
    ALPHA = circle_mask - mask;
    ALPHA_SCISSOR_THRESHOLD = 0.5;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
