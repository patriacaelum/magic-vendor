class_name Station
extends StaticBody3D


@onready var _coloured_mesh_3d := $ColouredMesh
@onready var _highlighted_mesh_3d := $HighlightedMesh
@onready var _drinks_container := %DrinksContainer


func highlight() -> void:
	self._coloured_mesh_3d.visible = false
	self._highlighted_mesh_3d.visible = true


func unhighlight() -> void:
	self._coloured_mesh_3d.visible = true
	self._highlighted_mesh_3d.visible = false


func get_drink_count() -> int:
	return self._drinks_container.get_child_count()


func has_drink() -> bool:
	return self.get_drink_count() > 0


func add_drink(drink: Drink) -> void:
	if not self.has_drink():
		drink.reparent(self._drink_container)


func get_drink() -> Drink:
	if self.has_drink():
		return self._drinks_container.get_child(0)

	return null
