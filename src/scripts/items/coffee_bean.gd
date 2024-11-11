class_name CoffeeBean
extends BaseItem


@onready var _black_coffee := preload("res://scenes/items/black_coffee.tscn")
@onready var _ingredient_mesh := %IngredientMesh
@onready var _powder_mesh := %PowderMesh


func apply(force: FORCE) -> void:
	if self._ingredient_mesh.visible and force == FORCE.GRIND:
		self._ingredient_mesh.visible = false
		self._powder_mesh.visible = true


func combine(item: BaseItem) -> BaseItem:
	if item is DrinkContainer or item is HotWater:
		item.queue_free()
		self.queue_free()

		var drink: BlackCoffee = self._black_coffee.instantiate()

		if item is DrinkContainer:
			drink.set_powder_mesh()

		return drink

	return null
