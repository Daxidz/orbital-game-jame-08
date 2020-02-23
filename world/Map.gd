extends Node2D

func _ready():
	pass


func _on_Area2D2_body_exited(body):
	if body.is_in_group("player"):
		body.take_damage(1)
	pass 
