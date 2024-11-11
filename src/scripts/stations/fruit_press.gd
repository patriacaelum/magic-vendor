class_name FruitPress
extends ProgressiveStation


## Start cooking timer when an indredient is placed in the pot. If the
## ingredient has already been cooked, then replacing it with a container will
## give back a completed item.
func add_item(item: BaseItem) -> BaseItem:
	if not self.has_items() and item is Apple:
		item.reparent(self._inventory)
		self._finished = false
		self.started.emit(self)

		return null
	elif self.has_items() and self._finished and item is DrinkContainer:
		var drink: BaseItem = self._inventory.get_child(0).combine(item)

		return drink

	return null


## The contents of the cooking station cannot be retrieved.
func get_item() -> BaseItem:
	return null


func operate(delta: float) -> void:
	if self.has_items() and not self._finished:
		self.progress += delta * self.progress_rate

		if self.progress >= 1:
			self._inventory.get_child(0).apply(BaseItem.FORCE.PRESSURE)
			self._finished = true
			self.finished.emit(self.get_instance_id())
