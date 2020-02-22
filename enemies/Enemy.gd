#File: Enemy.gd
extends Area2D

const DAMAGE = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _on_Enemy_body_entered(body):
	if body.get_name() == "Player":
		body.take_damage(DAMAGE)
	pass
