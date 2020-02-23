extends Node2D

func _ready():
	$AnimationPlayer.play('idle')

func _on_Glaire_body_entered(body):
	if body.is_in_group("player"):
		body.applySpeed(400, 2)
		$PowerUp.play()
