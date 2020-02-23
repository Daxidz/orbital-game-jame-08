extends Node

const TWO_PLAYERS = true

var Player = preload("res://player/Player.tscn")


func display_inGame_menu():
	for but in $InGameMenu.get_children():
		but.disabled = false
		but.visible = true
		
func hide_inGame_menu():
	for but in $InGameMenu.get_children():
		but.disabled = true
		but.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		display_inGame_menu()
		get_tree().paused = true
		

func start_game():
	var p1 = Player.instance()
	p1.id = 0
	p1.position = Vector2(200, 200)
	add_child(p1)
	
	p1.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
	p1.path_pos = $Map/Path2D/PathFollow2D
	
	
	if TWO_PLAYERS:
		var p2 = Player.instance()
		p2.id = 1
		p2.position = Vector2(64, 128)
		add_child(p2)
		p2.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
		p2.path_pos = $Map/Path2D/PathFollow2D
	
	
	for button in $MainMenu/Buttons.get_children():
		button.disabled = true
		button.visible = false
		
	$MainMenu/BG.hide()
	$MainMenu/Context1.show()
	yield(get_tree().create_timer(2), "timeout")
	
	$MainMenu/Context1.hide()
	
	$Map.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/Context1.hide()
	hide_inGame_menu()
	$Map.init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_StartButton_pressed():
	print("STARTING GAME")
	start_game()
	pass # Replace with function body.


func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_Credits_pressed():
	
	pass # Replace with function body.


func _on_Controls_pressed():
	pass # Replace with function body.


func _on_Resume_pressed():
	hide_inGame_menu()
	get_tree().paused = false
