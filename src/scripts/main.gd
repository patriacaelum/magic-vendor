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


var _current_level: int = 0
var _levels: Dictionary = {}
var _phase: PHASE = PHASE.PREPARATION
var _phase_change: float = 0


func _input(event: InputEvent) -> void:
    if event.is_action_released("operate") and self._phase == PHASE.PREPARATION:
        self._phase_change = 0


func _ready() -> void:
    self._player.station_placed.connect(self._on_player_station_placed)

    self._customer_manager.customer_spawned.connect(self._hud._on_customer_manager_customer_spawned)
    self._customer_manager.customer_order_fulfilled.connect(self._hud._on_customer_manager_customer_order_fulfilled)

    for vending_machine: VendingMachine in self._vending_machines.get_children():
        vending_machine.highlighted.connect(self._hud._on_vending_machine_highlighted)
        vending_machine.unhighlighted.connect(self._hud._on_vending_machine_unhighlighted)

    for station: ProgressiveStation in self._progressive_stations.get_children():
        station.started.connect(self._hud._on_progressive_station_started)
        station.finished.connect(self._hud._on_progressive_station_finished)

    self.__load_config()

    var next_level: Dictionary = self._levels.get(self._current_level + 1, {})
    self._hud.set_next_level(next_level.get("customers", 1))


func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("operate") and self._phase == PHASE.PREPARATION:
        self._phase_change += delta

        if self._phase_change >= 1:
            self.__set_phase(PHASE.SERVING)


func __load_config() -> void:
    var config := ConfigFile.new()
    var error := config.load("res://levels.toml")

    # If the file didn't load, ignore it
    if error != OK:
        return

    for key: String in config.get_sections():
        var level: int = int(key.split(".")[1])
        var customers: int = config.get_value(key, "customers")

        self._levels[level] = {"customers": customers}


func __set_phase(phase: PHASE) -> void:
    if phase == PHASE.PREPARATION:
        self._customer_manager.stop()
    elif phase == PHASE.SERVING:
        self._current_level += 1
        var n_customers: int = self._levels.get(self._current_level, {}).get("customers", 1)
        self._customer_manager.start(n_customers)

    self._hud.set_phase_label(phase)
    self._player.remap_control(phase)
    self._phase_change = 0
    self._phase = phase


func _on_player_station_placed(station: BaseStation) -> void:
    if station is VendingMachine:
        self._vending_machines.reparent(station)
    elif station is ProgressiveStation:
        self._progressive_stations.reparent(station)
    else:
        self.reparent(station)
