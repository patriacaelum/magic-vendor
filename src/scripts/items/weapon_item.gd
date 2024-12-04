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


@export var state: STATE = STATE.UNREFINED


var _timer := Timer.new()


func _init(init_material: MATERIAL, init_type: TYPE) -> void:
    self.material = init_material
    self.type = init_type


func _ready() -> void:
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)


func apply(force: FORCE) -> BaseItem:
    if self.state == STATE.UNREFINED and force == FORCE.HEAT:
        self.state = STATE.MALLEABLE
        self._timer.start(COOLDOWN_TIME[self._material])
    elif self._tate == STATE.MALLEABLE and force == FORCE.PRESSURE:
        self.state = STATE.ANNEALED
    elif self.state == STATE.ANNEALED and force == FORCE.WATER:
        self.state = STATE.REFINED
    elif self.state == STATE.REFINED and force == FORCE.GRIND:
        self.state = STATE.SHARPENED
    elif self.state == STATE.SHARPENED and force == FORCE.POLISH:
        self.state = STATE.POLISHED

    return null


func get_classname() -> String:
    return TYPE.keys()[self.state] + super()


func get_state_string() -> String:
    return STATE.keys()[self.state]


func _on_timer_timeout() -> void:
    if self.state == STATE.MALLEABLE or self.state == STATE.ANNEALED:
        self.state = STATE.UNREFINED
