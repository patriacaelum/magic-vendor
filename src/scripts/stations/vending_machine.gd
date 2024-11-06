class_name VendingMachine
extends Station


signal highlighted(vending_machine: VendingMachine)
signal unhighlighted(vending_machine_id: int)

@onready var _customer_queue_point := %CustomerQueuePoint


var queue_position: Vector3:
	get:
		return self._customer_queue_point.global_position


var _inventory_tracker: Dictionary = {}


## The vending machine also displays its inventory on the HUD when it is
## highlighted.
func highlight() -> void:
	super()
	self.highlighted.emit(self)


## The vending machine also hides its inventory on the HUD when it is no longer
## highlighted.
func unhighlight() -> void:
	super()
	self.unhighlighted.emit(self.get_instance_id())


## More than one drink can be added to the vending machine.
func add_inventory(item: InventoryItem) -> InventoryItem:
	if item.item_name == InventoryItem.NAME.DRINK:
		item.visible = false
		item.reparent(self._inventory)

		self._inventory_tracker.get_or_add(item.item_name, []).append(item)

	return null


## Drinks cannot be retrieved from the vending machine.
func get_inventory() -> InventoryItem:
	return null


## Drinks can only be taken as an order.
func get_order(order: Array[InventoryItem.NAME]) -> Array[InventoryItem]:
	var items: Array[InventoryItem] = []

	# Check if the order can be fulfilled
	for item_name: InventoryItem.NAME in order:
		if len(self._inventory_tracker.get(item_name, [])) == 0:
			return []

	# Add the items to the order
	for item_name: InventoryItem.NAME in order:
		items.append(self._inventory_tracker[item_name].pop_back())

	return items
