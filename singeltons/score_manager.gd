extends Node

var default_score : int = 1000

var level_selected : int = 1
var _level_scores : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_level_selected(ls : int):
	level_selected = ls
	
func get_level_selected():
	return level_selected
	
func check_and_add(level : String):
	if _level_scores.has(level) == false :
		_level_scores[level]=default_score
		
func set_score_for_level(score : int , level : String):
	check_and_add(level)
	if _level_scores[level] > score :
		_level_scores[level] = score
		
func get_best_for_level(level : String):
	check_and_add(level)
	return _level_scores[level]		
		
