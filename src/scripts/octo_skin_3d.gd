class_name OctoSkin3D
extends Node3D

@export var open_eye: CompressedTexture2D = null
@export var close_eye: CompressedTexture2D = null
@export var octo_mesh: MeshInstance3D = null

var _blink = true: set = _set_blink
var _open_eye_texture: CompressedTexture2D
var _closed_eye_texture: CompressedTexture2D
var left_eye_mat_override := 1
var right_eye_mat_override := 2


@onready var _blink_timer = %BlinkTimer
@onready var _closed_eyes_timer = %ClosedEyeTimer

@onready var _body_material := preload("res://assets/materials/octo_skin_3d.tres")
@onready var _left_eye_mat: StandardMaterial3D
@onready var _right_eye_mat: StandardMaterial3D

@onready var _animation_tree = $AnimationTree
@onready var _main_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")



## Sets model to neutral state
func idle():
	_main_state_machine.travel("Idle")

## Sets model to a walking state
func walk():
	_main_state_machine.travel("Walk")

## Sets model to a dash state
func dash():
	_main_state_machine.travel("Dash")

func _set_blink(state: bool):
	if _blink == state:
		return
	_blink = state
	if _blink:
		_blink_timer.start(0.2)
	else:
		_blink_timer.stop()
		_closed_eyes_timer.stop()
