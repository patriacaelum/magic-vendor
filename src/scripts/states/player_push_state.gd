class_name PlayerPushState
extends BasePlayerState


const CARDINALS: Array[Vector3] = [
    Vector3.LEFT,
    Vector3.RIGHT,
    Vector3.FORWARD,
    Vector3.BACK,
]


func notify(event: InputEvent) -> void:
    if event.is_action_released("grab"):
        self.finished.emit()


## Move toward the nearest grab point of the nearest station and push the
## station
func update(delta: float) -> void:
    # Move toward the nearest grab point of the nearest station
    var grab_point: Vector3 = 0.5 * self.__nearest_cardinal(
        self._entity.global_position,
        self._entity.current_station.global_position,
    )
    var grab_direction: Vector3 = self._entity.global_position.direction_to(grab_point)

    self._entity.velocity = grab_direction * self._entity.max_speed
    self._entity.move_and_slide()
    self._entity.look_at(grab_point)

    # Push the station in the direction parallel to the station
    # Stations cannot be pushed in a perpendicular direction
    var push_direction: Vector3 = self.__get_input_direction()

    if abs(push_direction.dot(grab_direction)) > 0.5:
        var force: Vector3 = (
            self._entity.push_force
            * self.__nearest_cardinal(push_direction).normalized()
        )
        self._entity.current_station.apply_force(force)


## Finds the nearest cardinal point from some point (the origin by default) to
## a cardinal direction with a specified centre point(also the origin by
## default).
func __nearest_cardinal(
    from: Vector3 = Vector3.ZERO,
    centre: Vector3 = Vector3.ZERO,
) -> Vector3:
    var nearest_cardinal: Vector3 = centre
    var nearest_distance: float = INF

    for cardinal: Vector3 in CARDINALS:
        # Using `distance_squared_to` because it is more optimized than
        # `distance_to` while maintaining the same result
        var cardinal_position: Vector3 = centre + cardinal
        var distance: float = from.distance_squared_to(cardinal_position)

        if distance < nearest_distance:
            nearest_distance = distance
            nearest_cardinal = cardinal_position

    return nearest_cardinal
        