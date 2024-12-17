class_name SupplyCrate
extends BaseStation


@export var supply_scene: PackedScene
@export var _is_debugging: bool = false
@export var _debugging_label: Label3D = null


var _supply_class: String


func _ready() -> void:
    super()

    assert(self.supply_scene != null, "SupplyCrate must supply a BaseItem!")

    # Create initial inventory
    var supply: BaseItem = self.supply_scene.instantiate()

    supply.visible = false
    self._inventory.add_child(supply)
    self._supply_class = supply.get_classname()
    if self._is_debugging:
        var label = supply.get_debug_string()
        self._debugging_label.text = label
        self._debugging_label.visible = true


## Supply crates only accept the item that they supply.
func add_item(item: BaseItem) -> BaseItem:
    if item.get_classname() == self._supply_class:
        item.reparent(self._inventory)
        self._audio_player.play()

    return null


## Supply crates have an infinite inventory.
func get_item_count() -> int:
    return 1


## Supply crates have an infinite inventory.
func has_items() -> bool:
    return true


## Spawn a new item if it doesn't exist.
func get_item() -> BaseItem:
    self._audio_player.play()

    if self._inventory.get_child_count() == 0:
        self._inventory.add_child(self.supply_scene.instantiate())

    var item: BaseItem = self._inventory.get_child(0)
    item.visible = true

    return item
