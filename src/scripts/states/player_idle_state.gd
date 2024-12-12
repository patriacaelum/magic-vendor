class_name PlayerIdleState
extends BasePlayerState


func _init() -> void:
    self.state_name = STATENAME.IDLE


func notify(event: InputEvent) -> void:
    var is_directional_input = (
        event.is_action_pressed("move_down")
        or event.is_action_pressed("move_left")
        or event.is_action_pressed("move_right")
        or event.is_action_pressed("move_up")
    )

    if is_directional_input:
        self.state_changed.emit(STATENAME.WALK)


func update(delta: float) -> void:
    self.__move(delta)
    self.__face_mouse()
    self._entity.check_front()
