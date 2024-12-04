class_name Forge
extends ProgressiveStation


const HEATING_TIME: Dictionary = {
    BaseItem.MATERIAL.BRONZE: 4.5,
    BaseItem.MATERIAL.IRON: 6,
    BaseItem.MATERIAL.STEEL: 7.5,
}


var _timer := Timer.new()


func _ready() -> void:
    super()
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)

    self.add_child(self._timer)


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is MaterialItem and item.state == MaterialItem.STATE.UNREFINED:
        item.reparent(self._inventory)
        self._finished = false
        self._timer.start(HEATING_TIME[item.material])
        self.started.emit(self)

        return null

    return null


func get_progress() -> float:
    return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time


func _on_timer_timeout() -> void:
    self._inventory.get_child(0).apply(BaseItem.FORCE.HEAT)
    self._finished = true
    self.finished.emit(self.get_instance_id())
