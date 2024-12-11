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

@onready var _mesh := preload("res://assets/mesh/props/items/sm_sword.tscn")


var _timer := Timer.new()


func _init(init_material: MATERIAL, init_type: TYPE) -> void:
    self.material = init_material
    self.type = init_type


func _ready() -> void:
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)

    self.add_child(self._timer)
    self.add_child(self._mesh.instantiate())
    
    self._debug_label = Label3D.new()
    self._debug_label.billboard = 1
    self._debug_label.position 
    self.add_child(_debug_label)
    self._is_debugging = true
    super()


func apply(force: FORCE) -> BaseItem:
    if self.state == STATE.UNREFINED and force == FORCE.HEAT:
        self.state = STATE.MALLEABLE
        self._timer.start(COOLDOWN_TIME[self.material])
    elif self.state == STATE.MALLEABLE and force == FORCE.PRESSURE:
        self.state = STATE.ANNEALED
    elif self.state == STATE.ANNEALED and force == FORCE.COOL:
        self.state = STATE.REFINED
    elif self.state == STATE.REFINED and force == FORCE.GRIND:
        self.state = STATE.SHARPENED
    elif self.state == STATE.SHARPENED and force == FORCE.POLISH:
        self.state = STATE.POLISHED

    print("Weapon is now ", STATE.keys()[self.state])
    super(force)
    return null


func get_classname() -> String:
    return STATE.keys()[self.state] + super()


func get_state_string() -> String:
    return STATE.keys()[self.state]


func _on_timer_timeout() -> void:
    if self.state == STATE.MALLEABLE or self.state == STATE.ANNEALED:
        self.state = STATE.UNREFINED
        _update_debug_label()
