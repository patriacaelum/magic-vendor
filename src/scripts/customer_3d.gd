class_name Customer3D
extends CharacterBody3D


const ORDER_ITEMS: Array[String] = [
    "REFINEDBRONZESTRAIGHTSWORD",
    "SHARPENEDBRONZESTRAIGHTSWORD",
]
const VIP_ORDER_ITEMS: Array[String] = [
    "POLISHEDBRONZESTRAIGHTSWORD",
]


signal order_fulfilled(customer: Customer3D)


@export var vip: bool = false

@onready var _area_3d := %Area3D
@onready var _navigation_agent_3d := %NavigationAgent3D


var target_lookat: Vector3 = Vector3.ZERO
var target_position: Vector3:
    get:
        return self._navigation_agent_3d.target_position
    set(value):
        self._navigation_agent_3d.target_position = value


var _order: Array[String]
var _speed: float = 100.0


func _ready() -> void:
    # Randomly select an order item
    var items: Array[String] = ORDER_ITEMS

    if vip:
        items = VIP_ORDER_ITEMS

    self._order = [items[randi_range(0, len(items) - 1)]]

    self._navigation_agent_3d.velocity_computed.connect(self._on_navigation_agent_3d_velocity_computed)
    self._navigation_agent_3d.navigation_finished.connect(self._on_navigation_agent_3d_navigation_finished)


func _physics_process(delta: float) -> void:
    if self._navigation_agent_3d.is_navigation_finished():
        self.__fulfill_order()
    else:
        var next_position: Vector3 = self._navigation_agent_3d.get_next_path_position()
        var direction = self.global_position.direction_to(next_position)

        self.look_at(next_position)
        self._navigation_agent_3d.set_velocity(direction * self._speed * delta)


func __fulfill_order() -> void:
    for body: Node3D in self._area_3d.get_overlapping_bodies():
        if body is not VendingMachine:
            continue

        var items: Array[BaseItem] = body.get_order(self._order)

        # Vending machine did not fulfill order, keep looking
        if not items:
            continue

        for item: BaseItem in items:
            item.reparent(self)

        self.order_fulfilled.emit(self)
        self._navigation_agent_3d.avoidance_priority = 0.8

        break


func _on_navigation_agent_3d_navigation_finished() -> void:
    var priority := 0.75

    if self.vip:
        priority = 0.85

    self._navigation_agent_3d.avoidance_priority = priority
    self.look_at(self.target_lookat)


func _on_navigation_agent_3d_path_changed() -> void:
    var priority := 0.7

    if self.vip:
        priority = 0.8

    self._navigation_agent_3d.avoidance_priority = priority


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
    self.velocity = safe_velocity
    self.move_and_slide()
