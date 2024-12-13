class_name Player3D
extends CharacterBody3D


@export_range(0.1, 2.0, 0.1) var dash_time := 0.5
@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
@export_range(1, 20, 1) var push_force := 10

## Controls how quickly the player accelerates and turns on the ground
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0


## A camera must be provided in every scene where the player is used
@onready var _inventory := %Inventory
@onready var _item_marker := %ItemMarker
@onready var _front_raycast_3d := %FrontRayCast
@onready var _octo_skin_3d: OctoSkin3D = %OctoSkin3D
@onready var _state_machine := %StateMachine


var _interact: Callable = self.__show_info
var _current_station: BaseStation = null

var current_station: BaseStation:
    get:
        return self._current_station


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        self._interact.call()
    else:
        self._state_machine.notify(event)


func _physics_process(delta: float) -> void:
    self._state_machine.update(delta)


func animate(state_name: State.STATENAME) -> void:
    match state_name:
        State.STATENAME.IDLE:
            self._octo_skin_3d.idle()
        State.STATENAME.WALK:
            self._octo_skin_3d.walk()
        State.STATENAME.DASH:
            self._octo_skin_3d.dash()


## Checks the front raycast and if it intersects a station, sends a signal to
## that station.
func check_front() -> void:
    var collider: Variant = self._front_raycast_3d.get_collider()

    # Only consider changing the current station if the raycast is empty or hits
    # a different station
    if collider != self._current_station:
        # Unhighlight the current station (unless it is empty)
        if self._current_station != null:
            self._current_station.unhighlight()

        if collider is BaseStation:
            self._current_station = collider
        else:
            self._current_station = null

        # Highlight the current station (unless it is empty)
        if self._current_station != null:
            self._current_station.highlight()


func remap_control(phase: Main.PHASE) -> void:
    match phase:
        Main.PHASE.PREPARATION:
            self._interact = self.__show_info
        Main.PHASE.SERVING:
            self._interact = self.__interact_with_station


func __add_item(item: BaseItem) -> void:
    if not item:
        return

    if item.get_parent():
        item.reparent(self._inventory)
    else:
        self._inventory.add_child(item)

    item.global_position = self._item_marker.global_position


func __add_station(station: BaseStation) -> void:
    if not station:
        return

    station.reparent(self._inventory)


func __has_items() -> bool:
    return self._inventory.get_child_count() > 0


func __interact_with_station() -> void:
    if not self._current_station:
        return

    if self.__has_items():
        # Sometimes, putting an item on a station returns another item
        var item: BaseItem = self._current_station.add_item(self._inventory.get_child(0))
        self.__add_item(item)

        if not self.__has_items():
            self._octo_skin_3d.drop()
    elif self._current_station.has_items():
        var item: BaseItem = self._current_station.get_item()
        self.__add_item(item)
        self._octo_skin_3d.pickup()


func __show_info() -> void:
    pass
