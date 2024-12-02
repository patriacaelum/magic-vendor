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


## Apply a force to the item. This may transform the state of the item.
func apply(force: FORCE) -> BaseItem:
	return null


## Combines the other item with this item. One or both items may be destroyed
## if the combination was successful.
func combine(item: BaseItem) -> BaseItem:
	return null


## Each item may have multiple states.
func get_state() -> int:
	return 0


## Each item may have multiple types.
func get_type() -> int:
	return 0
