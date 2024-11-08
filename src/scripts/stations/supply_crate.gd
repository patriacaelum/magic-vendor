class_name SupplyCrate
extends BaseStation


@export var supply_item: PackedScene


var _supply_class: String


func _ready() -> void:
	super()

	assert(self.supply_item != null, "SupplyCrate must supply a BaseItem!")

	# Create initial inventory
	var supply: BaseItem = self.supply_item.instantiate()

	self._supply_class = supply.get_class_name()
	self.add_child(supply)


## Supply crates only accept the item that they supply.
func add_item(item: BaseItem) -> BaseItem:
	if item.get_class_name() == self._supply_class:
		item.reparent(self._inventory)

	return null


## Supply crates have an infinite inventory.
func get_item_count() -> int:
	return 1


## Supply crates have an infinite inventory.
func has_items() -> bool:
	return true


## Spawn a new item if it doesn't exist.
func get_inventory() -> BaseItem:
	if self._inventory.get_child_count() == 0:
		self._inventory.add_child(self.supply_item.instantiate())

	return self._inventory.get_child(0)
