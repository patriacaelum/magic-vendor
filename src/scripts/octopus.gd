class_name Octopus
extends CharacterBody2D


const SPEED: float = 100.0

var __animator: AnimatedSprite2D


func _ready() -> void:
	self.__animator = $AnimatedSprite2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		self.velocity.y += self.SPEED
		self.__animator.play("down")
	elif event.is_action_released("ui_down"):
		self.velocity.y = 0
	elif event.is_action_pressed("move_left"):
		self.velocity.x += -self.SPEED
		self.__animator.play("left")
	elif event.is_action_released("move_left"):
		self.velocity.x = 0
	elif event.is_action_pressed("ui_right"):
		self.velocity.x += self.SPEED
		self.__animator.play("right")
	elif event.is_action_released("ui_right"):
		self.velocity.x = 0
	elif event.is_action_pressed("ui_up"):
		self.velocity.y += -self.SPEED
		self.__animator.play("up")
	elif event.is_action_released("ui_up"):
		self.velocity.y = 0


func _physics_process(delta: float) -> void:
	self.move_and_slide()
