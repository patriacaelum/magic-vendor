class_name Main
extends Node3D


@onready var _hud := %HUD
@onready var _vending_machines := %VendingMachineContainer


func _ready() -> void:
	for vending_machine: VendingMachine in self._vending_machines.get_children():
		vending_machine.highlighted.connect(self._hud._on_vending_machine_highlighted)
		vending_machine.unhighlighted.connect(self._hud._on_vending_machine_unhighlighted)
		vending_machine.hud_updated.connect(self._hud._on_vending_machine_hud_updated)
