extends Node2D
@onready var animal_start = $Animal_start
const ANIMAL = preload("res://animal.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
const UI = preload("res://ui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player_2d.play()
	_add_animal()
	SignalManager.on_animal_died.connect(_add_animal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(UI)

func _add_animal():
	var animal = ANIMAL.instantiate()
	animal.position = animal_start.position
	add_child(animal)
