class_name MaterialItem
extends BaseItem


enum STATE {
    UNREFINED,
    MALLEABLE,
}


@export var state: STATE = STATE.UNREFINED


var _timer := Timer.new()


func _ready() -> void:
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)


func apply(force: FORCE) -> BaseItem:
    if force == FORCE.HEAT:
        self.state = STATE.MALLEABLE
        self._timer.start(COOLDOWN_TIME[self.type])

    return null


func get_classname() -> String:
    return STATE.keys()[self.state] + super()


func get_state_string() -> String:
    return STATE.keys()[self.state]


func _on_timer_timeout() -> void:
    self._state = STATE.UNREFINED
