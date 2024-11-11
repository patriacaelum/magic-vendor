class_name Teapot
extends BaseItem


@onready var _empty_mesh := %EmptyMesh
@onready var _cold_water_mesh := %ColdWaterMesh
@onready var _boiling_water_mesh := %BoilingWaterMesh
@onready var _hot_water := preload("res://scenes/items/hot_water.tscn")


func apply(force: FORCE) -> void:
	if force == FORCE.FILL:
		self._empty_mesh.visible = false
		self._cold_water_mesh.visible = true
		self._boiling_water_mesh.visible = false
	elif force == FORCE.HEAT:
		self._empty_mesh.visible = false
		self._cold_water_mesh.visible = false
		self._boiling_water_mesh.visible = true


func combine(item: BaseItem) -> BaseItem:
	if self._boiling_water_mesh.visible and item is DrinkContainer:
		self._empty_mesh.visible = true
		self._cold_water_mesh.visible = false
		self._boiling_water_mesh.visible = false

		item.queue_free()

		return self._hot_water.instantiate()

	return null
