class_name CustomerManager
extends Node3D


signal customer_spawned(customer: Customer3D)
signal customer_order_fulfilled(customer_id: int)


@onready var _despawn_area := %DespawnArea
@onready var _spawn_point := %SpawnPoint
@onready var _timer := %Timer
@onready var _vending_machine_manager := %VendingMachineManager


var _customer_3d := preload("res://scenes/customer_3d.tscn")
var _customers: Dictionary = {}
var _n_customers: int = 0
var _n_customers_max: int = 0
var _queues: Dictionary = {}


func _ready() -> void:
    assert(
        self._vending_machine_manager != null,
        "Scene is missing a VendingMachineManager!",
    )

    self._despawn_area.body_entered.connect(self._on_despawn_area_body_entered)
    self._timer.timeout.connect(self._on_timer_timeout)


func start(n_customers_max: int) -> void:
    self._n_customers = 0
    self._n_customers_max = n_customers_max
    self._timer.start()


func stop() -> void:
    self._timer.stop()


func __spawn_customer() -> void:
    var customer: Customer3D = self._customer_3d.instantiate()
    var customer_id: int = customer.get_instance_id()
    var target: VendingMachine = self._vending_machine_manager.get_random()
    var target_id: int = target.get_instance_id()

    self.add_child(customer)
    self._customers[customer_id] = customer
    self._queues.get_or_add(target_id, []).append(customer_id)

    customer.position = self._spawn_point.position
    customer.target_lookat = target.global_position
    customer.target_position = target.global_position + (target.queue_position * len(self._queues[target_id]))
    customer.order_fulfilled.connect(self._on_customer_order_fulfilled)

    self.customer_spawned.emit(customer)


func __update_customer_target_positions() -> void:
    for vending_machine_id: int in self._queues:
        var vending_machine: VendingMachine = self._vending_machine_manager.get_by_id(vending_machine_id)
        var queue_position: int = 1

        for customer_id: int in self._queues[vending_machine_id]:
            var customer: Customer3D = self._customers[customer_id]

            customer.target_position = vending_machine.global_position + (vending_machine.queue_position * queue_position)
            queue_position += 1


func _on_despawn_area_body_entered(body: Node3D) -> void:
    if body is Customer3D:
        body.queue_free()


func _on_customer_order_fulfilled(customer: Customer3D) -> void:
    customer.target_position = self._despawn_area.global_position

    for customer_array: Array in self._queues.values():
        if customer_array and customer_array[0] == customer.get_instance_id():
            customer_array.pop_front()
            break

    self.__update_customer_target_positions()

    self.customer_order_fulfilled.emit(customer.get_instance_id())


func _on_timer_timeout() -> void:
    self.__spawn_customer()
    self._n_customers += 1

    if self._n_customers >= self._n_customers_max:
        self.stop()
