@tool 

## Exposes controls for a generic steam FX so that instances of the FX can have variations
extends GPUParticles3D

@export var custom_gradient: GradientTexture1D = GradientTexture1D.new()

func _ready():
    if not custom_gradient.gradient:
        custom_gradient.gradient = Gradient.new()
    
    if custom_gradient.gradient.get_point_count() == 0:
        self.custom_gradient.add_point(0.0, Color(1,1,1))
        self.custom_gradient.add_point(1.0, Color(0,0,0))
    apply_custom_gradient()

func apply_custom_gradient():
    if self.material_override:
        self.material_override = self.material_override.duplicate()
        self.material_override.set_shader_parameter("gradient_sampler", custom_gradient)
