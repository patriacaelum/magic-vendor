## Base class for all stations that have a progress bar associated with the
## process of manipulating an item.
class_name ProgressiveStation
extends BaseStation


signal started(station: ProgressiveStation)
signal finished(station_id: int)


const PROGRESS_MAX: float = 1.


## Progress rate is measured in Hz
@export var progress_rate: float = 0.5


var _finished: bool = false
var _progress: float = 0.


func get_item() -> BaseItem:
    if self.has_items() and self._finished:
        return self._inventory.get_child(0)

    return null


func get_progress() -> float:
    return self._progress


func __set_finished() -> void:
    self._finished = true
    self.finished.emit(self.get_instance_id())
