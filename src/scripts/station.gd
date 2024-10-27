class_name Station
extends StaticBody3D


@export var highlight_thickness := 0.08


@onready var _highlight_shader := preload("res://assets/shaders/simple_outline.gdshader")
@onready var _inventory := %Inventory
@onready var _mesh := %MeshInstance3D


var _highlight_material: ShaderMaterial


func _ready() -> void:
	self._highlight_material = ShaderMaterial.new()
	self._highlight_material.shader = self._highlight_shader


func highlight() -> void:
	if self._mesh.get_active_material(0).next_pass == null:
		self._mesh.get_active_material(0).next_pass = self._highlight_material

	self._set_outline_shader(0.0, self.highlight_thickness, 0.2)


func unhighlight() -> void:
	self._set_outline_shader(self.highlight_thickness, 0.0, 0.2)


func get_inventory_count() -> int:
	return self._inventory.get_child_count()


## Helper function to set outline material thickness
func _set_outline_shader(
	init_thickness: float,
	end_thickness: float,
	duration: float,
) -> void:
	var material: Material = self._mesh.get_active_material(0)
	var outline_mat: Material = material.get_next_pass()
	var tween = get_tree().create_tween()

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
