## A basic station acts like a countertop. An item can be placed on it, and can
## be retrieved from it. It is highlighted when the player is able to interact
## with it.
class_name BaseStation
extends RigidBody3D


@export var audio_random_pitch := 0.0
@export var audio_random_volume := 0.0
@export var highlight_thickness := 0.08
@export var _highlight_mesh: MeshInstance3D = null
@export var sfx: Array[AudioStream]

@onready var _highlight_shader := preload("res://assets/shaders/simple_outline.gdshader")

var _audio_player := AudioStreamPlayer.new()
var _inventory: Node3D
var _highlight_material := ShaderMaterial.new()


func _ready() -> void:
    var sfx_randomizer := AudioStreamRandomizer.new()
    sfx_randomizer.random_pitch += self.audio_random_pitch
    sfx_randomizer.random_volume_offset_db += self.audio_random_volume

    for sfx_: AudioStream in self.sfx:
        sfx_randomizer.add_stream(-1, sfx_)

    self._audio_player.stream = sfx_randomizer
    self._audio_player.bus = GLOBALS.AUDIO_BUS_SFX
    self.add_child(self._audio_player)

    self._inventory = self.get_node_or_null("Inventory")

    if not self._inventory:
        self._inventory = Node3D.new()
        self.add_child(self._inventory)

    self._highlight_material.shader = self._highlight_shader



## Depending on what the player is holding, adding an item to the station may
## or may not return an item back.
func add_item(item: BaseItem) -> BaseItem:
    if not self.has_items():
        item.reparent(self._inventory)

    return null


func get_item() -> BaseItem:
    if self.has_items():
        return self._inventory.get_child(0)

    return null


func get_item_count() -> int:
    return self._inventory.get_child_count()


func has_items() -> bool:
    return self.get_item_count() > 0


func highlight() -> void:
    if self._highlight_mesh.get_active_material(0).next_pass == null:
        self._highlight_mesh.get_active_material(0).next_pass = self._highlight_material

    self.__set_outline_shader(0.0, self.highlight_thickness, 0.2)


func operate(delta: float) -> void:
    pass


func unhighlight() -> void:
    self.__set_outline_shader(self.highlight_thickness, 0.0, 0.2)


## Helper function to set outline material thickness.
func __set_outline_shader(
    init_thickness: float,
    end_thickness: float,
    duration: float,
) -> void:
    var material: Material = self._highlight_mesh.get_active_material(0)
    var outline_mat: Material = material.get_next_pass()
    var tween = get_tree().create_tween()

    tween.tween_method(
        func(value): outline_mat.set_shader_parameter("inflate_amount", value),
        init_thickness,
        end_thickness,
        duration
    )
