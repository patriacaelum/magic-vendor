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
enum TYPE {
    STRAIGHTSWORD,
    SPEAR,
}


const COOLDOWN_TIME: Dictionary = {
    TYPE.STRAIGHTSWORD: 9,
    TYPE.SPEAR: 12,
}


var __timer := Timer.new()

var __state: STATE = STATE.UNREFINED
var __type: TYPE = TYPE.STRAIGHTSWORD


func _init(type: TYPE) -> void:
    self.__type = type


func _ready() -> void:
    self.__timer.one_shot = true
    self.__timer.timeout.connect(self._on_timer_timeout)


func apply(force: FORCE) -> BaseItem:
    if self.__state == STATE.UNREFINED and force == FORCE.HEAT:
        self.__state = STATE.MALLEABLE
        self.__timer.start(COOLDOWN_TIME[self.__type])
    elif self.__state == STATE.MALLEABLE and force == FORCE.PRESSURE:
        self.__state = STATE.ANNEALED
    elif self.__state == STATE.ANNEALED and force == FORCE.WATER:
        self.__state = STATE.REFINED
    elif self.__state == STATE.REFINED and force == FORCE.GRIND:
        self.__state = STATE.SHARPENED
    elif self.__state == STATE.SHARPENED and force == FORCE.POLISH:
        self.__state = STATE.POLISHED

    return null


func _on_timer_timeout() -> void:
    if self.__state == STATE.MALLEABLE or self.__state == STATE.ANNEALED:
        self.__state = STATE.UNREFINED