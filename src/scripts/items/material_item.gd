class_name MaterialItem
extends BaseItem


enum STATE {
    UNREFINED,
    MALLEABLE,
}


var _timer := Timer.new()
var _state: STATE = STATE.UNREFINED


func _ready() -> void:
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)


func apply(force: FORCE) -> BaseItem:
    if force == FORCE.HEAT:
        self._state = STATE.MALLEABLE
        self._timer.start(COOLDOWN_TIME[self._type])

    return null


func get_state() -> STATE:
    return self._state


func get_state_string() -> String:
    return STATE.keys()[self._state]


func _on_timer_timeout() -> void:
    self._state = STATE.UNREFINED
