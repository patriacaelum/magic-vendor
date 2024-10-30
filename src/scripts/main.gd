class_name Main
extends Node3D


@onready var _hud := %HUD
@onready var _customer_manager := %CustomerManager
@onready var _cooking_stations := %CookingStationContainer
@onready var _vending_machines := %VendingMachineManager


func _ready() -> void:
	self._customer_manager.customer_spawned.connect(self._hud._on_customer_manager_customer_spawned)
	self._customer_manager.customer_order_fulfilled.connect(self._hud._on_customer_manager_customer_order_fulfilled)

	for vending_machine: VendingMachine in self._vending_machines.get_children():
		vending_machine.highlighted.connect(self._hud._on_vending_machine_highlighted)
		vending_machine.unhighlighted.connect(self._hud._on_vending_machine_unhighlighted)

	for cooking_station: CookingStation in self._cooking_stations.get_children():
		cooking_station.started.connect(self._hud._on_cooking_station_started)
		cooking_station.finished.connect(self._hud._on_cooking_station_finished)
