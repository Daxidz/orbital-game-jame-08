extends Area2D

func _ready():
	pass


func _on_Ovary_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		body.win()
	pass # Replace with function body.
