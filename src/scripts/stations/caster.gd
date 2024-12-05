class_name Caster
extends ProgressiveStation


const CAST_TIME: int = 4


var _timer := Timer.new()


func _ready() -> void:
    super()
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)

    self.add_child(self._timer)


func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items() and item is MaterialItem and item.state == MaterialItem.STATE.MALLEABLE:
        item.reparent(self._inventory)
        self._finished = false
        self._timer.start(CAST_TIME)
        self.started.emit(self)

    return null


func get_progress() -> float:
    return (self._timer.wait_time - self._timer.time_left) / self._timer.wait_time


func _on_timer_timeout() -> void:
    var material: MaterialItem = self._inventory.get_child(0)

    material.apply(BaseItem.FORCE.COOL)
    material.type = BaseItem.TYPE.STRAIGHTSWORD

    self.__set_finished()
