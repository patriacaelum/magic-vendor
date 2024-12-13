class_name PlayerDashState
extends BasePlayerState


var _direction: Vector3 = Vector3.ZERO
var _timer := Timer.new()


func _ready() -> void:
    super()

    self._timer.one_shot = true
    self._timer.timeout.connect(self._on_timer_timout)

    self.add_child(self._timer)


func enter() -> void:
    super()

    self._direction = (
        self.__get_mouse_position() - self._entity.global_position
    ).normalized()
    self._timer.start(self._entity.dash_time)


func update(delta: float) -> void:
    self._entity.velocity = self.direction * self._entity.max_speed * 1.5
    self._entity.move_and_slide()


func _on_timer_timeout() -> void:
    self.finished.emit()