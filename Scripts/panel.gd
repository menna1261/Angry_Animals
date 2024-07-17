extends TextureButton

const HOVER_SCALE : Vector2 = Vector2(1.1,1.1)
const DEFAULT_SCALE : Vector2 = Vector2(1.0 , 1.0)
const init_scale : Vector2 = Vector2(3.0 , 3.0)

@export var level_number : int = 1

@onready var level_label = $MarginContainer/VBoxContainer/Label
@onready var score_label = $MarginContainer/VBoxContainer/Label2

var level_scene :PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = init_scale
	level_label.text = str(level_number)
	var bs = ScoreManager.get_best_for_level(str(level_number))
	score_label.text = str(bs)
	level_scene = load("res://level%s.tscn" %level_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	ScoreManager.set_level_selected(level_number)
	get_tree().change_scene_to_packed(level_scene)



func _on_mouse_entered():
	scale = HOVER_SCALE


func _on_mouse_exited():
	scale = DEFAULT_SCALE
