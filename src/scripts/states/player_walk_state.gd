class_name PlayerWalkState
extends BasePlayerState


func _init() -> void:
    self.state_name = STATENAME.WALK


func notify(event: InputEvent) -> void:
    if event.is_action_pressed("dash"):
        self.state_changed.emit(State.STATENAME.DASH)
        return

    var is_directional_input = (
        Input.is_action_pressed("move_down")
        or Input.is_action_pressed("move_left")
        or Input.is_action_pressed("move_right")
        or Input.is_action_pressed("move_up")
    )

    if not is_directional_input:
        self.finished.emit()


func update(delta: float) -> void:
    # Operate the nearest station
    if Input.is_action_pressed("operate") and self._entity.current_station:
        self.current_station.operate(delta)

    # Move in the direction of input
    var direction: Vector3 = self.__get_input_direction()

    if direction == Vector3.ZERO:
        self.finished.emit()
        return

    self.__move(delta, direction)
    self.__face_mouse()
    self._entity.check_front()