class_name BlackCoffee
extends BaseItem


@onready var _drink_mesh := %DrinkMesh
@onready var _powder_mesh := %PowderMesh


func set_drink_mesh() -> void:
    self._drink_mesh.visible = true
    self._powder_mesh.visible = false


func set_powder_mesh() -> void:
    self._drink_mesh.visible = false
    self.powder_mesh.visible = true