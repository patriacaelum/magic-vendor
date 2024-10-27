class_name InventoryItem
extends Node3D


enum NAME {
	NULL,
	DRINK,
	DRINK_CONTAINER,
	INGREDIENT,
}


@export var item_name := NAME.NULL


var _meshes := {
	NAME.DRINK: preload("res://scenes/items/drink.tscn"),
	NAME.DRINK_CONTAINER: preload("res://scenes/items/drink_container.tscn"),
	NAME.INGREDIENT: preload("res://scenes/items/ingredient.tscn"),
}


func _init(name_: NAME) -> void:
	assert(name_ != NAME.NULL, "InventoryItem must not be NULL!")
	self.item_name = name_
	self.add_child(self._meshes.get(name_).instantiate())
