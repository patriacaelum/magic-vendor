class_name Main
extends Node3D


enum PHASE {
	PREPARATION,
	SERVING,
}


@onready var _hud := %HUD
@onready var _customer_manager := %CustomerManager
@onready var _player := %Player3D
@onready var _progressive_stations := %ProgressiveStationContainer
@onready var _vending_machines := %VendingMachineManager


var _phase: PHASE = PHASE.PREPARATION
var _phase_change: float = 0


func _input(event: InputEvent) -> void:
	if event.is_action_released("operate") and self._phase == PHASE.PREPARATION:
		self._phase_change = 0


func _ready() -> void:
	self._customer_manager.customer_spawned.connect(self._hud._on_customer_manager_customer_spawned)
	self._customer_manager.customer_order_fulfilled.connect(self._hud._on_customer_manager_customer_order_fulfilled)

	for vending_machine: VendingMachine in self._vending_machines.get_children():
		vending_machine.highlighted.connect(self._hud._on_vending_machine_highlighted)
		vending_machine.unhighlighted.connect(self._hud._on_vending_machine_unhighlighted)

	for station: ProgressiveStation in self._progressive_stations.get_children():
		station.started.connect(self._hud._on_progressive_station_started)
		station.finished.connect(self._hud._on_progressive_station_finished)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("operate") and self._phase == PHASE.PREPARATION:
		self._phase_change += delta

		if self._phase_change >= 1:
			self.__set_phase(PHASE.SERVING)


func __set_phase(phase: PHASE) -> void:
	self._hud.set_phase_label(phase)
	self._player.remap_control(phase)
	self._phase_change = 0
	self._phase = phase
