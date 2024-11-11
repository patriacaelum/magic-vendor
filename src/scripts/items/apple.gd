class_name Apple
extends BaseItem


@onready var _apple_juice := preload("res://scenes/items/apple_juice.tscn")
@onready var _ingredient_mesh := %IngredientMesh
@onready var _pressed_mesh := %PressedMesh


func apply(force: FORCE) -> void:
	if self._ingredient_mesh.visible and force == FORCE.PRESSURE:
		self._ingredient_mesh.visible = false
		self._pressed_mesh.visible = true


func combine(item: BaseItem) -> BaseItem:
	if item is DrinkContainer:
		item.queue_free()
		self.queue_free()

		return self._apple_juice.instantiate()

	return null
