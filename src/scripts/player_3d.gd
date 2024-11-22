class_name Player3D
extends CharacterBody3D


@export_range(3.0, 12.0, 0.1) var max_speed := 6.0

## Controls how quickly the player accelerates and turns on the ground
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0


## A camera must be provided in every scene where the player is used
@onready var _camera_3d := %Camera3D
@onready var _inventory := %Inventory
@onready var _item_marker := %ItemMarker
@onready var _front_raycast_3d := %FrontRayCast
@onready var _octo_skin_3d: OctoSkin3D = %OctoSkin3D

const GRAVITY: Vector3 = 40.0 * Vector3.DOWN


var _current_station: BaseStation = null
var _world_plane := Plane(Vector3.UP)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not self._current_station:
			return

		if self.__has_items():
			var item: BaseItem = self._current_station.add_item(self._inventory.get_child(0))
			self.__add_item(item)
		elif self._current_station.has_items():
			var item: BaseItem = self._current_station.get_item()
			self.__add_item(item)


func _physics_process(delta: float) -> void:
	if self._current_station and Input.is_action_pressed("operate"):
		self._current_station.operate(delta)

	self.__move(delta)
	self.__face_mouse()
	self.__check_front()


func __add_item(item: BaseItem) -> void:
	if not item:
		return

	if item.get_parent():
		item.reparent(self._inventory)
	else:
		self._inventory.add_child(item)

	item.global_position = self._item_marker.global_position


## Checks the front raycast and if it intersects a station, sends a signal to
## that station.
func __check_front() -> void:
	var collider: Variant = self._front_raycast_3d.get_collider()

	# Only consider changing the current station if the raycast is empty or hits
	# a different station
	if collider != self._current_station:
		# Unhighlight the current station (unless it is empty)
		if self._current_station != null:
			self._current_station.unhighlight()

		if collider is BaseStation:
			self._current_station = collider
		else:
			self._current_station = null

		# Highlight the current station (unless it is empty)
		if self._current_station != null:
			self._current_station.highlight()


## Turns the player torward the direction of the mouse.
func __face_mouse() -> void:
	# Project ray from camera to the ground, find position of mouse in 3D space
	self._world_plane.d = self.global_position.y
	var mouse_position_2d: Vector2 = self.get_viewport().get_mouse_position()
	var mouse_ray: Vector3 = self._camera_3d.project_ray_normal(mouse_position_2d)
	var world_mouse_position: Variant = self._world_plane.intersects_ray(
		self._camera_3d.global_position,
		mouse_ray,
	)

	# Character faces the mouse
	if world_mouse_position:
		self.look_at(world_mouse_position)


func __has_items() -> bool:
	return self._inventory.get_child_count() > 0


## Moves the player in toward the direction of input.
func __move(delta: float) -> void:
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
	
	# Update the skin animation based on movement.
	if is_on_floor() and not direction.is_zero_approx():
		_octo_skin_3d.walk()
	else:
		_octo_skin_3d.idle()
