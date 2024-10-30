class_name CookingStation
extends Station


signal started(cooking_station: CookingStation)
signal finished(cooking_station_id: int)


@onready var _timer := %Timer


var _finished: bool = false


func _ready() -> void:
	super()
	self._timer.timeout.connect(self._on_timer_timeout)


## When cooking is finished, replace the ingredient with the drink.
func _on_timer_timeout() -> void:
	if self._inventory.get_child_count() > 0:
		self._inventory.get_child(0).queue_free()

	var drink_fluid := InventoryItem.new(InventoryItem.NAME.DRINK_FLUID)
	self._inventory.add_child(drink_fluid)

	self._finished = true
	self.finished.emit(self.get_instance_id())


## Start cooking timer when an indredient is placed in the pot. If the
## ingredient has already been cooked, then replacing it with a container will
## give back a completed item.
func add_inventory(item: InventoryItem) -> InventoryItem:
	if not self.has_inventory() and item.item_name == InventoryItem.NAME.INGREDIENT:
		item.reparent(self._inventory)
		self._timer.start()
		self.started.emit(self)
	elif self.has_inventory() and item.item_name == InventoryItem.NAME.DRINK_CONTAINER:
		item.queue_free()
		self._inventory.get_child(0).queue_free()
		var drink: InventoryItem = InventoryItem.new(InventoryItem.NAME.DRINK)
		self._inventory.add_child(drink)

		return drink

	return null


## The contents of the cooking station cannot be retrieved.
func get_inventory() -> InventoryItem:
	return null


func get_progress() -> float:
	return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time
