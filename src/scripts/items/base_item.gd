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


var _material: MATERIAL = MATERIAL.NULL
var _type: TYPE = TYPE.NULL


## Apply a force to the item. This may transform the state of the item.
func apply(force: FORCE) -> BaseItem:
	return null


## Combines the other item with this item. One or both items may be destroyed
## if the combination was successful.
func combine(item: BaseItem) -> BaseItem:
	return null


## Each item may be made of a material.
func get_material() -> MATERIAL:
	return self._material


## Each item may have multiple states.
func get_state() -> int:
	return 0


## Each item may be classified as a type.
func get_type() -> TYPE:
	return self._type
