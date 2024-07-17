extends Node2D


@onready var ground_hit = $AudioStreamPlayer2D

func _process(delta):
	pass

func _on_body_entered(body):
	ground_hit.play()
