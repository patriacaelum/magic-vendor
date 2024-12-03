class_name CastItem
extends BaseItem


enum STATE {
    EMPTY,
    FILLED,
}


var _state := STATE.EMPTY


func apply(force: FORCE) -> BaseItem:
    if self._state == STATE.FILLED and force == FORCE.WATER:
        self.queue_free()

        return WeaponItem.new(self._material, self._type)

    return null


func combine(item: BaseItem) -> BaseItem:
    if item is MaterialItem and item.get_state() == MaterialItem.STATE.MALLEABLE:
        self._material = item.get_material()
        self._state = self.FILLED_STATE

        item.queue_free()

        return self

    return null


func get_state() -> STATE:
    return self._state


func get_state_string() -> String:
    return STATE.keys()[self._state]