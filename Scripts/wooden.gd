extends StaticBody2D
@onready var animation_player = $AnimationPlayer

func _ready():
	pass # Replace with function body.
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _die():
	animation_player.play("vanishing")
	


func _on_animation_player_animation_finished(anim_name):
	SignalManager.on_cup_destroyed.emit()
	queue_free()
