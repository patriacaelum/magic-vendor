class_name Forge
extends ProgressiveStation


@onready var _timer := %Timer


func _ready() -> void:
    super()
    self._timer.timeout.connect(self._on_timer_timeout)


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is WeaponItem:
        item.reparent(self._inventory)
        self._finished = false
        self._timer.start()
        self.started.emit(self)

        return null
    elif self.has_items() and self._finished and item is CastItem:
        var drink: BaseItem = self._inventory.get_child(0).combine(item)

        return drink

    return null


func get_progress() -> float:
    return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time


func _on_timer_timeout() -> void:
    self._inventory.get_child(0).apply(BaseItem.FORCE.HEAT)
    self._finished = true
    self.finished.emit(self.get_instance_id())
