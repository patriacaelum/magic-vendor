class_name MainMenu
extends Control


@onready var _start_button := %StartButton
@onready var _quit_button := %QuitButton
@onready var _main := preload("res://scenes/main.tscn")


func _ready() -> void:
    self._start_button.pressed.connect(self._on_start_button_pressed)
    self._quit_button.pressed.connect(self._on_quit_button_pressed)
    self._start_button.grab_focus()


func _on_start_button_pressed() -> void:
    get_tree().change_scene_to_packed(self._main)


func _on_quit_button_pressed() -> void:
    get_tree().quit()