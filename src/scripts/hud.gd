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
@onready var _vending_machine_label := %VendingMachineLabel
@onready var _cooking_station_label := %CookingStationLabel


var _cooking_stations: Dictionary = {}
var _customer_orders: Dictionary = {}
var _customer_order_label := preload("res://scenes/hud/customer_order_label.tscn")
var _vending_machines: Dictionary = {}


func _ready():
	pass


func _process(delta):
	var time_elapsed: int = floor(Time.get_ticks_msec()/1000)
	var format_time_label := "[center] %s [/center]"
	self._timer_label.text = format_time_label % time_elapsed

	for customer_id: int in self._customer_orders:
		self.__update_customer_order(self._customer_orders[customer_id])

	for vending_machine_id: int in self._vending_machines:
		self.__update_vending_machine_label(self._vending_machines[vending_machine_id])

	for cooking_station_id: int in self._cooking_stations:
		self.__update_cooking_station_label(self._cooking_stations[cooking_station_id])


func _on_customer_manager_customer_spawned(customer: Customer3D) -> void:
	var label: RichTextLabel = self._customer_order_label.instantiate()
	var order := CustomerOrder.new(customer, label)

	self.__update_customer_order(order)
	self._customer_orders[customer.get_instance_id()] = CustomerOrder.new(
		customer,
		label,
	)
	self.add_child(label)


func _on_customer_manager_customer_despawned(customer_id: int) -> void:
	self._customer_orders[customer_id].label.queue_free()
	self._customer_orders.erase(customer_id)


func _on_cooking_station_started(cooking_station: CookingStation) -> void:
	self._cooking_stations[cooking_station.get_instance_id()] = cooking_station
	self.__update_cooking_station_label(cooking_station)
	self._cooking_station_label.visible = true


func _on_cooking_station_finished(cooking_station_id: int) -> void:
	self._cooking_stations.erase(cooking_station_id)
	self._cooking_station_label.visible = false


func _on_vending_machine_highlighted(vending_machine: VendingMachine) -> void:
	self._vending_machines[vending_machine.get_instance_id()] = vending_machine
	self.__update_vending_machine_label(vending_machine)
	self._vending_machine_label.visible = true


func _on_vending_machine_unhighlighted(vending_machine_id) -> void:
	self._vending_machines.erase(vending_machine_id)
	self._vending_machine_label.visible = false


func __update_customer_order(customer_order: CustomerOrder) -> void:
	customer_order.label.position = self.__viewport_position(customer_order.customer)


func __update_cooking_station_label(cooking_station: CookingStation) -> void:
	self._cooking_station_label.value = cooking_station.get_progress() * self._cooking_station_label.max_value
	self._cooking_station_label.position = self.__viewport_position(cooking_station)


func __update_vending_machine_label(vending_machine: VendingMachine) -> void:
	self._vending_machine_label.text = "[center]%s[/center]" % vending_machine.get_inventory_count()
	self._vending_machine_label.position = self.__viewport_position(vending_machine)


func __viewport_position(object: Node3D) -> Vector2:
	return self._camera_3d.unproject_position(object.global_position)
