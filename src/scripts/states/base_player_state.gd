# The base class for all states that control the player character.
class_name BasePlayerState
extends State


@onready var _camera: Camera3D = %Camera3D

var _entity: Player3D
var _world_plane := Plane(Vector3.UP)


func _ready() -> void:
    self._entity = self.get_parent().get_parent()

    assert(self._camera != null, "Player3D requires a Camera3D node in the scene!")


func enter() -> void:
    self._entity.animate(self.state_name)


## Turns the player toward the direction of the mouse.
func __face_mouse() -> void:
    self._entity.look_at(self.__get_mouse_position())


func __get_input_direction() -> Vector3:
    var input_vector: Vector2 = Input.get_vector(
        "move_left",
        "move_right",
        "move_up",
        "move_down",
    )

    return Vector3(input_vector.x, 0.0, input_vector.y)


## Project a ray from the camera to the ground to find the position of the
## mosue in 3D space.
func __get_mouse_position() -> Vector3:
    var mouse_position_2d: Vector2 = self.get_viewport().get_mouse_position()
    self._world_plane.d = self._entity.global_position.y

    var raycast: Vector3 = self._camera.project_ray_normal(mouse_position_2d)
    var mouse_position_3d: Vector3 = self._world_plane.intersects_ray(
        self.camera.global_position,
        raycast,
    )

    return mouse_position_3d


## Moves the player in the specified direction.
func __move(delta: float, direction: Vector3 = Vector3.ZERO) -> void:
    var desired_velocity: Vector3 = direction * self._entity.max_speed
    var steering_velocity: Vector3 = desired_velocity - self._entity.velocity
    var steering_factor: float = min(self._entity.steering_factor * delta, 1.0)

    # Avoid steering in y-direction since it is controlled by gravity
    steering_velocity.y = 0.0

    self._entity.velocity += (
        (steering_velocity * steering_factor)
        + (self.GRAVITY * delta)
    )
    self._entity.move_and_slide()