class_name BaseItem
extends Node3D


enum FORCE {
	FILL,
	HEAT,
	GRIND,
	PRESSURE,
	WATER,
}


var classname: String:
	get:
		return self.get_script().get_global_name()


## Apply a force to the item. This may transform the state of the item.
func apply(force: FORCE) -> void:
	pass


## Combines the other item with this item. Both items should be destroyed
## if the combination was successful.
func combine(item: BaseItem) -> BaseItem:
	return null
