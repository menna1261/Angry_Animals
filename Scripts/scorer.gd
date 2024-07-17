extends Node


var _attempts : int = 0
var _cups_hit :  int = 0
var _total_cups : int = 0
var _level_selected : int = 1

func _ready():
	_total_cups = get_tree().get_nodes_in_group("wooden").size()
	_level_selected = ScoreManager.get_level_selected()
	SignalManager.on_attempt_made.connect(attempt_made)
	SignalManager.on_cup_destroyed.connect(cup_hit)

func attempt_made():
	_attempts += 1
	SignalManager.on_score_updated.emit(_attempts)
	
	
func cup_hit():
	_cups_hit +=1 
	if _cups_hit == _total_cups:
		SignalManager.on_cup_destroyed.emit()
		SignalManager.on_level_completed.emit()
		ScoreManager.set_score_for_level(_attempts , str(_level_selected))
