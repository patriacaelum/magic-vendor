class_name SupplyCrate
extends BaseStation


@export var supply_scene: PackedScene
@export var supply_material: BaseItem.MATERIAL
@export var supply_type: BaseItem.TYPE


var _supply_class: String


func _ready() -> void:
    super()

    assert(self.supply_scene != null, "SupplyCrate must supply a BaseItem!")

    # Create initial inventory
    var supply: BaseItem = self.supply_scene.instantiate()

    supply.visible = false
    self._supply_class = supply.get_classname()
    self.add_child(supply)


## Supply crates only accept the item that they supply.
func add_item(item: BaseItem) -> BaseItem:
    if item.get_classname() == self._supply_class:
        item.reparent(self._inventory)

    return null


## Supply crates have an infinite inventory.
func get_item_count() -> int:
    return 1


## Supply crates have an infinite inventory.
func has_items() -> bool:
    return true


## Spawn a new item if it doesn't exist.
func get_item() -> BaseItem:
    if self._inventory.get_child_count() == 0:
        self._inventory.add_child(self.supply_scene.instantiate())

    var item: BaseItem = self._inventory.get_child(0)
    item.visible = true

    return item
