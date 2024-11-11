class_name ProgressiveStation
extends BaseStation


signal started(station: ProgressiveStation)
signal finished(station_id: int)


const PROGRESS_MAX: float = 1.


## Progress rate is measured in Hz
@export var progress_rate: float = 0.5


var _finished: bool = false
var _progress: float = 0.


func get_progress() -> float:
    return self._progress