extends Node2D

func _ready():
	$AnimationPlayer.play('idle')
	
func _on_Spermicide_body_entered(body):
	if body.is_in_group("player"):
		body.applySpeed(-600, 2)
