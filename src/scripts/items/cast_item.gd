class_name CastItem
extends BaseItem


enum STATE {
    EMPTY,
    FILLED,
}
enum TYPE {
    STRAIGHTSWORD,
    SPEAR,
}


const WEAPON_TYPE: Dictionary = {
    TYPE.STRAIGHTSWORD: WeaponItem.TYPE.STRAIGHTSWORD,
    TYPE.SPEAR: WeaponItem.TYPE.SPEAR,
}


var __type := TYPE.STRAIGHTSWORD
var __state := STATE.EMPTY


func _init(type: TYPE) -> void:
    self.__type = type


func apply(force: FORCE) -> BaseItem:
    if self.__state == STATE.FILLED and force == FORCE.WATER:
        self.queue_free()

        return WeaponItem.new(WEAPON_TYPE[self.__type])

    return null


func combine(item: BaseItem) -> BaseItem:
    if item is MaterialItem and item.get_state() == MaterialItem.STATE.HEATED:
        item.queue_free()
        self.__state = self.FILLED_STATE

        return self

    return null


func get_state() -> STATE:
    return STATE.keys()[self.__state]


func get_type() -> TYPE:
    return TYPE.keys()[self.__type]