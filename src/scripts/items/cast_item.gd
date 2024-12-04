class_name CastItem
extends BaseItem


enum STATE {
    EMPTY,
    FILLED,
}


@export var state := STATE.EMPTY


func apply(force: FORCE) -> BaseItem:
    if self.state == STATE.FILLED and force == FORCE.WATER:
        self.queue_free()

        return WeaponItem.new(self.material, self.type)

    return null


func combine(item: BaseItem) -> BaseItem:
    if item is MaterialItem and item.state == MaterialItem.STATE.MALLEABLE:
        self.material = item.material
        self.state = self.FILLED_STATE

        item.queue_free()

        return self

    return null


func get_classname() -> String:
    return STATE.keys()[self.state] + super()


func get_state_string() -> String:
    return STATE.keys()[self.state]
