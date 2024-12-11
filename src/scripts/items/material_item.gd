class_name MaterialItem
extends BaseItem


enum STATE {
    UNREFINED,
    MALLEABLE,
}


@export var state: STATE = STATE.UNREFINED

@onready var _unrefined_mesh := %UnrefinedMesh
@onready var _malleable_mesh := %MalleableMesh


var _timer := Timer.new()


func _ready() -> void:
    self.type = TYPE.STRAIGHTSWORD
    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timeout)

    self.add_child(self._timer)
    super()


func apply(force: FORCE) -> BaseItem:
    if force == FORCE.HEAT:
        self.__set_state(STATE.MALLEABLE)
        self._timer.start(COOLDOWN_TIME[self.material])
    elif force == FORCE.COOL and self.state == STATE.MALLEABLE:
        var weapon := WeaponItem.new(self.material, self.type)

        self.add_sibling(weapon)
        self.queue_free()
    
    super(force)
    return null


func get_classname() -> String:
    return STATE.keys()[self.state] + super()


func get_state_string() -> String:
    return STATE.keys()[self.state]


func __set_state(new_state: STATE) -> void:
    match new_state:
        STATE.UNREFINED:
            self._unrefined_mesh.visible = true
            self._malleable_mesh.visible = false
        STATE.MALLEABLE:
            self._unrefined_mesh.visible = false
            self._malleable_mesh.visible = true

    self.state = new_state
    self._update_debug_label()


func _on_timer_timeout() -> void:
    self.__set_state(STATE.UNREFINED)
