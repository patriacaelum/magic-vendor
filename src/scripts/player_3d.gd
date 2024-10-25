class_name Player3D
extends CharacterBody3D


@export_range(3.0, 12.0, 0.1) var max_speed := 6.0

## Controls how quickly the player accelerates and turns on the ground
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0


@onready var _octo_skin_3d := %OctoSkin3D
@onready var _camera_3d := %Camera3D


const GRAVITY: Vector3 = 40.0 * Vector3.DOWN


var _world_plane := Plane(Vector3.UP)


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down",
	)
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)

	# Implement steering for smoother handling
	var desired_ground_velocity: Vector3 = direction * self.max_speed
	var steering_vector: Vector3 = desired_ground_velocity - self.velocity

	# Avoid smoothing for y-direction as it is not controlled through input
	steering_vector.y = 0.0

	# Limit steering to ensure velocity never overshoots desired velocity
	var steering_amount: float = min(self.steering_factor * delta, 1.0)

	self.velocity += (steering_vector * steering_amount) + (self.GRAVITY * delta)
	move_and_slide()

	# Project ray from camera to the ground, find position of mouse in 3D space
	self._world_plane.d = self.global_position.y
	var mouse_position_2d: Vector2 = self.get_viewport().get_mouse_position()
	var mouse_ray: Vector3 = self._camera_3d.project_ray_normal(mouse_position_2d)
	var world_mouse_position: Variant = self._world_plane.intersects_ray(
		self._camera_3d.global_position,
		mouse_ray,
	)

	# Character faces the mouse
	if world_mouse_position != null:
		self._octo_skin_3d.look_at(world_mouse_position)
