## Base class for all items. Items are considered things that the player can
## put in their inventory.
class_name BaseItem
extends Node3D


enum FORCE {
    COOL,
    HEAT,
    GRIND,
    POLISH,
    PRESSURE,
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

@export_category("Debugging")
@export var _debug_label: Label3D = null
@export var _is_debugging := false

@export_category("Item")
@export var material: MATERIAL = MATERIAL.NULL
@export var type: TYPE = TYPE.NULL

func _ready() -> void:
    _update_debug_label()

## Apply a force to the item. This may transform the state of the item.
func apply(force: FORCE) -> BaseItem:
    _update_debug_label()
    return null


## Combines the other item with this item. One or both items may be destroyed
## if the combination was successful.
func combine(item: BaseItem) -> BaseItem:
    _update_debug_label()
    return null


func get_classname() -> String:
    return MATERIAL.keys()[self.material] + TYPE.keys()[self.type]


func get_state_string() -> String:
    return "NULL"

func get_debug_string() -> String:
    var label := get_classname()
    label = label.replace("NULL", "")
    return label

func _update_debug_label() -> void:
    if self._is_debugging and self._debug_label != null:
        self._debug_label.text = get_debug_string()
