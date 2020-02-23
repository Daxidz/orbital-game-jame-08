extends Node

const TWO_PLAYERS = false

var Player = preload("res://player/Player.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var p1 = Player.instance()
	p1.id = 0
	p1.position = Vector2(200, 200)
	add_child(p1)
	
	p1.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D2
	p1.path_pos = $Map/Path2D/PathFollow2D
	
	if TWO_PLAYERS:
		var p2 = Player.instance()
		p2.id = 1
		p2.position = Vector2(64, 128)
		add_child(p2)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
