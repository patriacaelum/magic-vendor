class_name PlayerWalkState
extends BasePlayerState


@export var audio_random_pitch := 0.0
@export var audio_random_volume := 0.0
@export var sfx: Array[AudioStream]
@export_range(0.1, 1.0, 0.05) var step_time: float = 0.5
@export_range(-5, 5, 0.1) var volume: float = 0.0

var _audio_player := AudioStreamPlayer.new()
var _step_timer := Timer.new()


func _init() -> void:
    self.state_name = STATENAME.WALK


func _ready() -> void:
    super()

    var sfx_randomizer := AudioStreamRandomizer.new()
    sfx_randomizer.random_pitch += self.audio_random_pitch
    sfx_randomizer.random_volume_offset_db += self.audio_random_volume

    for sfx_: AudioStream in self.sfx:
        sfx_randomizer.add_stream(-1, sfx_)

    self._audio_player.stream = sfx_randomizer
    self._audio_player.bus = GLOBALS.AUDIO_BUS_SFX
    self._audio_player.volume_db = self.volume
    self.add_child(self._audio_player)

    self._step_timer.timeout.connect(self._on_step_timer_timeout)
    self.add_child(self._step_timer)


func enter() -> void:
    super()
    self._step_timer.start(self.step_time)


func exit() -> void:
    self._step_timer.stop()
    super()


func notify(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        self._entity.interact.call()
        return
    if event.is_action_pressed("dash"):
        self.state_changed.emit(State.STATENAME.DASH)
        return
    elif event.is_action_pressed("grab"):
        self.state_changed.emit(State.STATENAME.PUSH)
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


func _on_step_timer_timeout() -> void:
    self._audio_player.play()