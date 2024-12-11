class_name Crucible
extends BaseItem


var _inventory := Node3D.new()


func _ready() -> void:
    self.add_child(self._inventory)
    super()


func combine(item: BaseItem) -> BaseItem:
    if item is MaterialItem and item.state == MaterialItem.STATE.MALLEABLE:
        item.reparent(self._inventory)

    return null


func get_contents() -> BaseItem:
    if self._inventory.get_child_count() > 0:
        return self._inventory.get_child(0)

    return null
