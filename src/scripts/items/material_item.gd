class_name MaterialItem
extends BaseItem


enum STATE {
    UNREFINED,
    HEATED,
}
enum TYPE {
    BRONZE,
    IRON,
    STEEL,
}


## The cooldown times are based on the melting points of each metal.
## A higher melting point results in a longer cooldown time.
const COOLDOWN_TIME: Dictionary = {
    TYPE.BRONZE: 9,
    TYPE.IRON: 12,
    TYPE.STEEL: 15,
}


var __timer := Timer.new()

var __state: STATE = STATE.UNREFINED
var __type: TYPE = TYPE.STEEL


func _init(type: TYPE) -> void:
    self.__type = type


func _ready() -> void:
    self.__timer.one_shot = true
    self.__timer.timeout.connect(self._on_timer_timeout)



func apply(force: FORCE) -> BaseItem:
    if force == FORCE.HEAT:
        self.__state = STATE.HEATED
        self.__timer.start(COOLDOWN_TIME[self.__type])

    return null


func get_state() -> STATE:
    return self.__state


func get_type() -> TYPE:
    return self.__type


func _on_timer_timeout() -> void:
    self.__state = STATE.UNREFINED