extends Control


@onready var _customers_served_label := %CustomersServedLabel
@onready var _timer_label := %TimerLabel
@onready var _level_label := %LevelLabel
@onready var _vending_machine_label := %VendingMachineLabel


func _ready():
	pass


func _process(delta):
	var time_elapsed: int = floor(Time.get_ticks_msec()/1000)
	var format_time_label := "[center] %s [/center]"
	self._timer_label.text = format_time_label % time_elapsed


func _on_vending_machine_highlighted() -> void:
	self._vending_machine_label.visible = true


func _on_vending_machine_unhighlighted() -> void:
	self._vending_machine_label.visible = false


func _on_vending_machine_hud_updated(viewport_position: Vector2, n_drinks: int) -> void:
	self._vending_machine_label.text = "[center]%s[/center]" % n_drinks
	self._vending_machine_label.position = viewport_position
