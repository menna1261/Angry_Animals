extends Control

@onready var vb1 = $MarginContainer/VBoxContainer
@onready var vb2 = $MarginContainer/VBoxContainer2
@onready var level_label = $MarginContainer/VBoxContainer/level_Label
@onready var attempts_label = $MarginContainer/VBoxContainer/attempts_label
@onready var win = $AudioStreamPlayer2D

const GAME_UI = preload("res://game.tscn")

const UI = preload("res://ui.tscn")
func _ready():
	level_label.text = "LEVEL %s " %ScoreManager.get_level_selected()
	update_attempts(0)
	SignalManager.on_score_updated.connect(update_attempts)
	SignalManager.on_level_completed.connect(level_complete)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu") == true :
		get_tree().change_scene_to_packed(UI)
	
func update_attempts(attempts : int ):
	attempts_label.text = "ATTEMPTS %s" % attempts
	
func level_complete():
	vb2.show()
	win.play()


	
