class_name Station
extends StaticBody3D

@export var highlight_mesh : MeshInstance3D = null
@onready var highlight_shader := preload("res://assets/shaders/simple_outline.gdshader")
var highlight_material : ShaderMaterial

@onready var _coloured_mesh_3d := $ColouredMesh
@onready var _highlighted_mesh_3d := $HighlightedMesh
@onready var _inventory := %Inventory
@onready var is_highlighted := false

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


func get_inventory_count() -> int:
	return self._inventory.get_child_count()


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
	)


func has_inventory() -> bool:
	return self.get_inventory_count() > 0


## Depending on what the player is holding, adding an item to the station may
## or may not return an item back.
func add_inventory(item: InventoryItem) -> InventoryItem:
	if not self.has_inventory():
		item.reparent(self._inventory)

	return null


func get_inventory() -> InventoryItem:
	if self.has_inventory():
		return self._inventory.get_child(0)

	return null
