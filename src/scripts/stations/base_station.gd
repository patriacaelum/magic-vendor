## A basic station acts like a countertop. An item can be placed on it, and can
## be retrieved from it. It is highlighted when the player is able to interact
## with it.
class_name BaseStation
extends AnimatableBody3D


@export var highlight_thickness := 0.08


@onready var _highlight_shader := preload("res://assets/shaders/simple_outline.gdshader")
@onready var _inventory := %Inventory
@onready var _mesh := %MeshInstance3D


var _highlight_material: ShaderMaterial


func _ready() -> void:
	assert(self._inventory != null, "Station is missing Inventory node!")
	assert(self._mesh != null, "Station missing MeshInstance3D!")
	self._highlight_material = ShaderMaterial.new()
	self._highlight_material.shader = self._highlight_shader


## Depending on what the player is holding, adding an item to the station may
## or may not return an item back.
func add_item(item: BaseItem) -> BaseItem:
	if not self.has_items():
		item.reparent(self._inventory)

	return null


func get_item() -> BaseItem:
	if self.has_items():
		return self._inventory.get_child(0)

	return null


func get_item_count() -> int:
	return self._inventory.get_child_count()


func has_items() -> bool:
	return self.get_item_count() > 0


func highlight() -> void:
	if self._mesh.get_active_material(0).next_pass == null:
		self._mesh.get_active_material(0).next_pass = self._highlight_material

	self.__set_outline_shader(0.0, self.highlight_thickness, 0.2)


func operate(delta: float) -> void:
	pass


func unhighlight() -> void:
	self.__set_outline_shader(self.highlight_thickness, 0.0, 0.2)


## Helper function to set outline material thickness.
func __set_outline_shader(
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
