class_name OctoSkin3D
extends Node3D


@export var left_eye_mat_override := 1
@export var right_eye_mat_override := 2
@export var open_eye: CompressedTexture2D = null
@export var close_eye: CompressedTexture2D = null


@onready var blink_timer = %BlinkTimer
@onready var closed_eye_timer = %ClosedEyeTimer


@onready var _body_material := preload("res://assets/materials/octo_skin_3d.tres")
@onready var _left_eye_mat: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
