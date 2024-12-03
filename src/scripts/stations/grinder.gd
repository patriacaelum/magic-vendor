class_name Grinder
extends ProgressiveStation


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is WeaponItem:
        item.reparent(self._inventory)
        self._finished = false
        self.started.emit(self)

        return null
    elif self.has_items() and self._finished:
        var drink: BaseItem = self._inventory.get_child(0).combine(item)

        return drink

    return null


## The contents of the grinder cannot be retrieved.
func get_item() -> BaseItem:
    return null


func operate(delta: float) -> void:
    if self.has_items() and not self._finished:
        self._progress += delta * self.progress_rate

        if self._progress >= self.PROGRESS_MAX:
            self._inventory.get_child(0).apply(BaseItem.FORCE.GRIND)
            self._finished = true
            self.finished.emit(self.get_instance_id())
