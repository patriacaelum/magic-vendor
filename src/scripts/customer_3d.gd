class_name Customer3D
extends CharacterBody3D


@onready var _navigation_agent_3d := %NavigationAgent3D


var target_position: Vector3:
	set(value):
		self._navigation_agent_3d.target_position = value


var _speed: float = 100.0


func _physics_process(delta: float) -> void:
	if self._navigation_agent_3d.is_target_reached():
		return

	var direction = self.global_position.direction_to(
		self._navigation_agent_3d.get_next_path_position(),
	)
	self.velocity = direction * self._speed * delta
	self.move_and_slide()
