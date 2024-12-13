class_name Trashcan
extends BaseStation


var _trash_count: int = 0


## Trashcan accepts all items and destroys them.
func add_item(item: BaseItem) -> BaseItem:
    item.reparent(self._inventory)
    item.queue_free()
    self._trash_count += 1

    return null


## Items cannot be retrieved from Trashcan.
func get_item() -> BaseItem:
    return null


func get_item_count() -> int:
    return self._trash_count
