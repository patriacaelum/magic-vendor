class_name SupplyCrate
extends Station


@export var supply_item: InventoryItem.NAME


func _ready() -> void:
	super()
	assert(
		self.supply_item != InventoryItem.NAME.NULL,
		"SupplyCrate must not supply NULL!",
	)


## Supply crates have an infinite inventory.
func get_inventory_count() -> int:
	return 1


## Supply crates have an infinite inventory.
func has_inventory() -> bool:
	return true


## Supply crates only accept the item that the supply.
func add_inventory(item: InventoryItem) -> InventoryItem:
	if item.item_name == InventoryItem.NAME.INGREDIENT:
		item.reparent(self._inventory)

	return null


## Spawn a new item if it doesn't exist.
func get_inventory() -> InventoryItem:
	if self._inventory.get_child_count() == 0:
		self._inventory.add_child(InventoryItem.new(self.supply_item))

	return self._inventory.get_child(0)
