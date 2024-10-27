class_name VendingMachine
extends Station


signal highlighted
signal unhighlighted
signal hud_updated(viewport_position: Vector2, n_drinks: int)


## A camera must be provided in every scene where the vending machine is used.
@onready var _camera_3d := %Camera3D


func _physics_process(delta: float) -> void:
	if self.is_highlighted:
		self.__update_hud()


## The vending machine also displays its inventory on the HUD when it is
## highlighted.
func highlight() -> void:
	super()
	self.__update_hud()
	self.highlighted.emit()


## The vending machine also hides its inventory on the HUD when it is no longer
## highlighted.
func unhighlight() -> void:
	super()
	self.unhighlighted.emit()


## More than one drink can be added to the vending machine.
func add_drink(drink: Drink) -> void:
	drink.visible = false
	drink.reparent(self._drinks_container)


## Drinks cannot be retrieved from the vending machine.
func get_drink() -> Drink:
	return null


func __update_hud() -> void:
	var viewport_position: Vector2 = self._camera_3d.unproject_position(
		self.global_position,
	)
	self.hud_updated.emit(viewport_position, self.get_drink_count())
