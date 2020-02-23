extends Node2D

func _ready():
	pass

func start():
	$Path2D.started = true
	
func init():
	$Path2D.init()

func _on_Area2D2_body_exited(body):
	if body.is_in_group("player"):
		print("PLAYER OUT")
		body.take_damage(1)
	pass 
