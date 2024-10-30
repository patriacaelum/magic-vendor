class_name CustomerManager
extends Node3D


signal customer_spawned(customer: Customer3D)
signal customer_order_fulfilled(customer_id: int)


@onready var _despawn_area := %DespawnArea
@onready var _spawn_point := %SpawnPoint
@onready var _timer := %Timer
@onready var _vending_machine_manager := %VendingMachineManager


var _customer_3d := preload("res://scenes/customer_3d.tscn")


func _ready() -> void:
	assert(
		self._vending_machine_manager != null,
		"Scene is missing a VendingMachineManager!",
	)

	self._despawn_area.body_entered.connect(self._on_despawn_area_body_entered)
	self._timer.timeout.connect(self._on_timer_timeout)


func _on_despawn_area_body_entered(body: Node3D) -> void:
	if body is Customer3D:
		body.queue_free()


func _on_customer_order_fulfilled(customer: Customer3D) -> void:
	customer.target_position = self._despawn_area.global_position
	self.customer_order_fulfilled.emit(customer.get_instance_id())


func _on_timer_timeout() -> void:
	var customer: Customer3D = self._customer_3d.instantiate()

	self.add_child(customer)
	customer.position = self._spawn_point.position
	customer.target_position = self._vending_machine_manager.get_random_queue_position()
	customer.order_fulfilled.connect(self._on_customer_order_fulfilled)

	self.customer_spawned.emit(customer)
