extends Control


@onready var customers_served_label := $HBoxContainer/CustomersServedLabel
@onready var timer_label := $HBoxContainer/TimerLabel
@onready var level_label := $HBoxContainer/LevelLabel


func _ready():
	pass # Replace with function body.


func _process(delta):
	var time_elapsed:int = floor(Time.get_ticks_msec()/1000)
	var format_time_label := "[center] %s [/center]"
	timer_label.text = format_time_label % time_elapsed
