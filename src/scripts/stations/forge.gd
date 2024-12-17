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
    if self.has_items():
        if item is Crucible:
            item.combine(self._inventory.get_child(0))

        return null

    if item is MaterialItem and item.state == MaterialItem.STATE.UNREFINED:
        item.reparent(self._inventory)
        self.__heat_item(item)
    elif item is WeaponItem and item.state == WeaponItem.STATE.UNREFINED:
        item.reparent(self._inventory)
        self.__heat_item(item)

    return null


func get_item() -> BaseItem:
    var item = self._inventory.get_child(0)

    if item is MaterialItem and item.state == MaterialItem.STATE.MALLEABLE:
        return null

    return item


func get_progress() -> float:
    return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time


func __heat_item(item: BaseItem) -> void:
    self._timer.start(HEATING_TIME[item.material])
    self._audio_player.play()

    self._finished = false
    self.started.emit(self)


func _on_timer_timeout() -> void:
    self._inventory.get_child(0).apply(BaseItem.FORCE.HEAT)
    self._audio_player.stop()

    self.__set_finished()
