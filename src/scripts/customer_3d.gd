class_name Customer3D
extends CharacterBody3D


signal order_fulfilled(customer: Customer3D)


@onready var _area_3d := %Area3D
@onready var _navigation_agent_3d := %NavigationAgent3D


var _order: Array[BaseItem] = [AppleJuice.new()]


var target_position: Vector3:
	set(value):
		self._navigation_agent_3d.target_position = value


var _speed: float = 100.0


func _physics_process(delta: float) -> void:
	if self._navigation_agent_3d.is_target_reached():
		self.__fulfill_order()

	var direction = self.global_position.direction_to(
		self._navigation_agent_3d.get_next_path_position(),
	)
	self.velocity = direction * self._speed * delta
	self.move_and_slide()


func __fulfill_order() -> void:
	for body: Node3D in self._area_3d.get_overlapping_bodies():
		if body is not VendingMachine:
			continue

		var items: Array[BaseItem] = body.get_order(self._order)

		# Vending machine did not fulfill order, keep looking
		if not items:
			continue

		# for item: InventoryItem in items:
		for item in items:
			item.reparent(self)

		self.order_fulfilled.emit(self)
		break
