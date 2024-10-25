class_name VendingMachine
extends Station


func get_drink() -> Drink:
	return null


func stock_drink(drink: Drink) -> void:
	drink.reparent(self._drinks_container)
