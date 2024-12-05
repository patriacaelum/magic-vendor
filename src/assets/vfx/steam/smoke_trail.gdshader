shader_type spatial;
#include "res://assets/vfx/billboard.gdshaderinc"

render_mode shadows_disabled, unshaded, particle_trails;

uniform sampler2D gradient_sampler : filter_linear, source_color;
uniform sampler2D smoke_texture : filter_linear, source_color;

varying vec4 custom;
varying vec3 vertex_pos;

void vertex() {
    mat4 billboard_mvm = apply_billboarding(INV_VIEW_MATRIX, MODELVIEW_MATRIX, VIEW_MATRIX, MODEL_MATRIX, INSTANCE_CUSTOM);
    MODELVIEW_MATRIX = billboard_mvm;
    MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
    custom = INSTANCE_CUSTOM;
    vertex_pos = VERTEX;

	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 particleUV = vec2(UV.x, vertex_pos.y);
    vec3 test_text = texture(smoke_texture, particleUV).rgb;
    ALBEDO = vec3(particleUV,0.0);
    //ALBEDO = test_text;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
