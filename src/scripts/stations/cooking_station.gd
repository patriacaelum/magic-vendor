class_name CookingStation
extends BaseStation


signal started(cooking_station: CookingStation)
signal finished(cooking_station_id: int)


@onready var _timer := %Timer


var progress: float:
	get:
		return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time


var _finished: bool = false


func _ready() -> void:
	super()
	self._timer.timeout.connect(self._on_timer_timeout)


## When cooking is finished, replace the ingredient with the drink.
func _on_timer_timeout() -> void:
	self._inventory.get_child(0).apply(BaseItem.FORCE.PRESSURE)

	self._finished = true
	self.finished.emit(self.get_instance_id())


## Start cooking timer when an indredient is placed in the pot. If the
## ingredient has already been cooked, then replacing it with a container will
## give back a completed item.
func add_item(item: BaseItem) -> BaseItem:
	if not self.has_items() and item.classname == "Apple":
		item.reparent(self._inventory)
		self._timer.start()
		self.started.emit(self)

		return null
	elif self.has_items() and item.classname == "DrinkContainer":
		var drink: BaseItem = self._inventory.get_child(0).combine(item)

		return drink

	return null


## The contents of the cooking station cannot be retrieved.
func get_item() -> BaseItem:
	return null
