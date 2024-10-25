class_name Station
extends StaticBody3D


@onready var _coloured_mesh_3d := $ColouredMesh
@onready var _highlighted_mesh_3d := $HighlightedMesh
@onready var _drinks_container := %DrinksContainer


var highlighted: bool:
	get:
		return self._highlighted_mesh_3d.visible
	set(value):
		self._coloured_mesh_3d.visible = not value
		self._highlighted_mesh_3d.visible = value


func get_drink() -> Drink:
	if self.has_drink():
		return self._drinks_container.get_child(0)

	return null


func has_drink() -> bool:
	return self._drinks_container.get_child_count() > 0


func stock_drink(drink: Drink) -> void:
	if not self.has_drink():
		drink.reparent(self._drink_container)
