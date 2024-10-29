class_name VendingMachineVendor
extends Node3D


func get_random_queue_position() -> Vector3:
	var index: int = randi_range(0, self.get_child_count() - 1)

	return self.get_child(index).queue_position
