extends Node


var Player = preload("res://player/Player.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var p1 = Player.instance()
	p1.id = 0
	var p2 = Player.instance()
	p2.id = 1
	
	p1.position = Vector2(64, 64)
	p2.position = Vector2(64, 128)
	
	add_child(p1)
#	add_child(p2)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
