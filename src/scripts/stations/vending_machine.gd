class_name VendingMachine
extends BaseStation


signal highlighted(vending_machine: VendingMachine)
signal unhighlighted(vending_machine_id: int)


@onready var _sword_placements := %SwordPlacements
@onready var _customer_queue_marker := %CustomerQueueMarker
@onready var _animation_player := %AnimationPlayer

var queue_position: Vector3:
    get:
        return self._customer_queue_marker.position


var _inventory_tracker: Dictionary = {}
var _sword_marker_tracker: Dictionary = {}

func _ready():
    super()
    # Initialize sword marker placements dict
    for marker in self._sword_placements.get_children():
        _sword_marker_tracker[marker] = false

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
func add_item(item: BaseItem) -> BaseItem:
    if item is WeaponItem:

        item.reparent(self._inventory)
        self._inventory_tracker.get_or_add(item.get_classname(), []).append(item)
        print(item.get_classname(), "added to vending machine")

        # Find first unused marker and place an item
        for marker in _sword_marker_tracker.keys():
            if _sword_marker_tracker[marker] == false:
                item.global_transform = marker.global_transform
                print("Marker position " + str(item.global_position) + " Sword position: " + str(item.global_position))
                _sword_marker_tracker[marker] = true

                return null
        
        # Visibility if all markers are used
        item.visible = false

    return null

## Play animation to process the order
func anim_process_order() -> void:
    self._animation_player.play('process_order')

## Drinks cannot be retrieved from the vending machine.
func get_item() -> BaseItem:
    return null


## Drinks can only be taken as an order.
func get_order(order: Array[String]) -> Array[BaseItem]:
    var items: Array[BaseItem] = []

    # Check if the order can be fulfilled
    for item_name: String in order:
        if len(self._inventory_tracker.get(item_name, [])) == 0:
            return []

    # Add the items to the order
    for item_name: String in order:
        items.append(self._inventory_tracker[item_name].pop_back())

    return items
