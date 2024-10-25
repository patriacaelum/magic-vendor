class_name Station
extends StaticBody3D


@onready var _coloured_mesh_3d := $ColouredMesh
@onready var _highlighted_mesh_3d := $HighlightedMesh
@onready var _drinks_container := %DrinksContainer


var drink: Drink:
	get:
		if self.has_drink():
			return self._drinks_container.get_child(0)
		return null
	set(value):
		value.reparent(self._drinks_container)

var highlighted: bool:
	get:
		return self._highlighted_mesh_3d.visible
	set(value):
		self._coloured_mesh_3d.visible = not value
		self._highlighted_mesh_3d.visible = value


func has_drink() -> bool:
	return self._drinks_container.get_child_count() > 0
