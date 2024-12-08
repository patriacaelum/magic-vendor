@tool
## Editor tool: Attach to a GPUParticle3D scene to preview instantaneous burst VFX on a looping basis with `One Shot` enabled
extends GPUParticles3D

## Controls loop duration of the One-Shot particle system
@export_range (0.1, 10, 0.1) var loop_duration := 2.0 :
    get:
        return loop_duration
    set(value):
        loop_duration = max(value, 0.1)

## Time elapsed in-editor 
var _timer: float = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if not Engine.is_editor_hint():
        return
    
    self._timer += delta
    if self._timer >= loop_duration:
        self._timer = 0.0
        self.restart()

