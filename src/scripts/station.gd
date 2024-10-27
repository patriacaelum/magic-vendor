class_name Station
extends StaticBody3D

@export var highlight_mesh : MeshInstance3D = null
@onready var highlight_shader := preload("res://assets/shaders/simple_outline.gdshader")
var highlight_material : ShaderMaterial

@onready var _coloured_mesh_3d := $ColouredMesh
@onready var is_highlighted := false
@onready var _drinks_container := %DrinksContainer

@export var highlight_thickness := 0.08

func _ready() -> void:
	self.highlight_material = ShaderMaterial.new()
	self.highlight_material.shader = highlight_shader
	
func highlight() -> void:

	assert(highlight_mesh != null,
		"No highlight mesh assigned, please assign one in inspector"
	)
	if self.highlight_mesh.get_active_material(0).get_next_pass() == null:
		self.highlight_mesh.get_active_material(0).set_next_pass(self.highlight_material)
	_set_outline_shader(0.0, self.highlight_thickness, 0.2)
	
	self.is_highlighted = true

func unhighlight() -> void:
	_set_outline_shader(self.highlight_thickness, 0.0, 0.2)
	self.is_highlighted = false

## Helper function to set outline material thickness
func _set_outline_shader(init_thickness: float, end_thickness: float, duration: float) -> void:
	var material : Material = self.highlight_mesh.get_active_material(0)
	var outline_mat : Material = material.get_next_pass()
	assert(outline_mat != null,
		"No outline material assigned" +
		"Please assign outline shader to the next pass material"
	)
	
	var tween = get_tree().create_tween();
	tween.tween_method(
		func(value): outline_mat.set_shader_parameter("inflate_amount", value),
		init_thickness,
		end_thickness,
		duration
	);
	
func get_drink_count() -> int:
	return self._drinks_container.get_child_count()


func has_drink() -> bool:
	return self.get_drink_count() > 0


func add_drink(drink: Drink) -> void:
	if not self.has_drink():
		drink.reparent(self._drinks_container)


func get_drink() -> Drink:
	if self.has_drink():
		return self._drinks_container.get_child(0)

	return null
