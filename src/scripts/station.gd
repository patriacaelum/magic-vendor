class_name Station
extends StaticBody3D


@onready var _coloured_mesh_3d := $ColouredMesh
@onready var _highlighted_mesh_3d := $HighlightedMesh
@onready var _inventory := %Inventory


func highlight() -> void:
	self._coloured_mesh_3d.visible = false
	self._highlighted_mesh_3d.visible = true


func unhighlight() -> void:
	self._coloured_mesh_3d.visible = true
	self._highlighted_mesh_3d.visible = false


func get_inventory_count() -> int:
	return self._inventory.get_child_count()


func has_inventory() -> bool:
	return self.get_inventory_count() > 0


func add_inventory(item: InventoryItem) -> void:
	if not self.has_inventory():
		item.reparent(self._inventory)


func get_inventory() -> InventoryItem:
	if self.has_inventory():
		return self._inventory.get_child(0)

	return null
