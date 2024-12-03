class_name WeaponItem
extends BaseItem


enum STATE {
    UNREFINED,
    MALLEABLE,
    ANNEALED,
    REFINED,
    SHARPENED,
    POLISHED,
}


var _timer := Timer.new()
var _state: STATE = STATE.UNREFINED


func _init(material: MATERIAL, type: TYPE) -> void:
    self._material = material
    self._type = type


func _ready() -> void:
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)


func apply(force: FORCE) -> BaseItem:
    if self._state == STATE.UNREFINED and force == FORCE.HEAT:
        self._state = STATE.MALLEABLE
        self._timer.start(COOLDOWN_TIME[self._material])
    elif self._state == STATE.MALLEABLE and force == FORCE.PRESSURE:
        self._state = STATE.ANNEALED
    elif self._state == STATE.ANNEALED and force == FORCE.WATER:
        self._state = STATE.REFINED
    elif self._state == STATE.REFINED and force == FORCE.GRIND:
        self._state = STATE.SHARPENED
    elif self._state == STATE.SHARPENED and force == FORCE.POLISH:
        self._state = STATE.POLISHED

    return null


func get_state() -> STATE:
    return self._state


func get_state_string() -> String:
    return STATE.keys()[self._state]


func _on_timer_timeout() -> void:
    if self._state == STATE.MALLEABLE or self._state == STATE.ANNEALED:
        self._state = STATE.UNREFINED