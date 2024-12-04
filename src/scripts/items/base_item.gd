## Base class for all items. Items are considered things that the player can
## put in their inventory.
class_name BaseItem
extends Node3D


enum FORCE {
    FILL,
    HEAT,
    GRIND,
    POLISH,
    PRESSURE,
    WATER,
}
enum MATERIAL {
    NULL,
    BRONZE,
    IRON,
    STEEL,
}
enum TYPE {
    NULL,
    STRAIGHTSWORD,
    SPEAR,
}


## The cooldown times are based on the melting points of each metal.
## A higher melting point results in a longer cooldown time.
const COOLDOWN_TIME: Dictionary = {
    MATERIAL.BRONZE: 9,
    MATERIAL.IRON: 12,
    MATERIAL.STEEL: 15,
}


@export var material: MATERIAL = MATERIAL.NULL
@export var type: TYPE = TYPE.NULL


## Apply a force to the item. This may transform the state of the item.
func apply(force: FORCE) -> BaseItem:
    return null


## Combines the other item with this item. One or both items may be destroyed
## if the combination was successful.
func combine(item: BaseItem) -> BaseItem:
    return null


func get_classname() -> String:
    return MATERIAL.keys()[self.material] + TYPE.keys()[self.type]


func get_state_string() -> String:
    return "NULL"
