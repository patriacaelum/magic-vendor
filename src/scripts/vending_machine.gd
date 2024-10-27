class_name VendingMachine
extends Station


signal highlighted(vending_machine: VendingMachine)
signal unhighlighted(vending_machine_id: int)


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

	return null


## Drinks cannot be retrieved from the vending machine.
func get_inventory() -> InventoryItem:
	return null
