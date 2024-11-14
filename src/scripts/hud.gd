class_name HUD
extends Control


class CustomerOrder:
	var customer: Customer3D
	var label: RichTextLabel

	func _init(customer_: Customer3D, label_: RichTextLabel) -> void:
		self.customer = customer_
		self.label = label_


## A camera must be used whenever a HUD is used
@onready var _camera_3d := %Camera3D
@onready var _customers_served_label := %CustomersServedLabel
@onready var _timer_label := %TimerLabel
@onready var _level_label := %LevelLabel
@onready var _phase_label := %PhaseLabel
@onready var _vending_machine_label := %VendingMachineLabel
@onready var _progress_label := %ProgressLabel


var _customer_orders: Dictionary = {}
var _customer_order_label := preload("res://scenes/hud/customer_order_label.tscn")
var _customers_served: int = 0
var _progressive_stations: Dictionary = {}
var _vending_machines: Dictionary = {}


func _ready():
	pass


func _process(delta: float) -> void:
	var time_elapsed: int = floor(Time.get_ticks_msec()/1000)
	var format_time_label := "[center] %s [/center]"
	self._timer_label.text = format_time_label % time_elapsed


func _physics_process(delta: float) -> void:
	for customer_order: CustomerOrder in self._customer_orders.values():
		self.__update_customer_order(customer_order)

	for vending_machine: VendingMachine in self._vending_machines.values():
		self.__update_vending_machine_label(vending_machine)

	for station: ProgressiveStation in self._progressive_stations.values():
		self.__update_progress_label(station)


func set_phase_label(phase: Main.PHASE) -> void:
	match phase:
		Main.PHASE.PREPARATION:
			self._phase_label.text = "[center]Preparation Phase[/center]"
		Main.PHASE.SERVING:
			self._phase_label.text = "[center]Serving Phase[/center]"


func __update_progress_label(station: ProgressiveStation) -> void:
	self._progress_label.value = station.get_progress() * self._progress_label.max_value
	self._progress_label.position = self.__viewport_position(station)


func __update_vending_machine_label(vending_machine: VendingMachine) -> void:
	self._vending_machine_label.text = "[center]%s[/center]" % vending_machine.get_item_count()
	self._vending_machine_label.position = self.__viewport_position(vending_machine)


func __viewport_position(object: Node3D) -> Vector2:
	return self._camera_3d.unproject_position(object.global_position)


func __update_customer_order(customer_order: CustomerOrder) -> void:
	customer_order.label.position = self.__viewport_position(customer_order.customer)


func _on_customer_manager_customer_spawned(customer: Customer3D) -> void:
	var label: RichTextLabel = self._customer_order_label.instantiate()
	var order := CustomerOrder.new(customer, label)

	self.__update_customer_order(order)
	self._customer_orders[customer.get_instance_id()] = CustomerOrder.new(
		customer,
		label,
	)
	self.add_child(label)


func _on_customer_manager_customer_order_fulfilled(customer_id: int) -> void:
	self._customer_orders[customer_id].label.queue_free()
	self._customer_orders.erase(customer_id)

	self._customers_served += 1
	self._customers_served_label.text = "[center]x%d[/center]" % self._customers_served


func _on_progressive_station_started(station: ProgressiveStation) -> void:
	self._progressive_stations[station.get_instance_id()] = station
	self.__update_progress_label(station)
	self._progress_label.visible = true


func _on_progressive_station_finished(station_id: int) -> void:
	self._progressive_stations.erase(station_id)
	self._progress_label.visible = false


func _on_vending_machine_highlighted(vending_machine: VendingMachine) -> void:
	self._vending_machines[vending_machine.get_instance_id()] = vending_machine
	self.__update_vending_machine_label(vending_machine)
	self._vending_machine_label.visible = true


func _on_vending_machine_unhighlighted(vending_machine_id) -> void:
	self._vending_machines.erase(vending_machine_id)
	self._vending_machine_label.visible = false
