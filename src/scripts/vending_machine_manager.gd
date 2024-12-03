class_name VendingMachineVendor
extends Node3D


var _vending_machines: Dictionary = {}


func _ready() -> void:
    for vending_machine: VendingMachine in self.get_children():
        self._vending_machines[vending_machine.get_instance_id()] = vending_machine


func get_by_id(vending_machine_id: int) -> VendingMachine:
    return self._vending_machines[vending_machine_id]


func get_random() -> VendingMachine:
    var index: int = randi_range(0, self.get_child_count() - 1)

    return self.get_child(index)
