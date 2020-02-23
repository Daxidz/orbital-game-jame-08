extends Node

const TWO_PLAYERS = false

var Player = preload("res://player/Player.tscn")


func display_inGame_menu():
	for but in $Menu.get_children():
		but.disabled = false
		but.visible = true
		
func hide_inGame_menu():
	for but in $Menu.get_children():
		but.disabled = true
		but.visible = false
		
func display_players_bar():
	$PlayersLife/Bar.visible = true
func hide_players_bar():
	$PlayersLife/Bar.visible = false
		
func hide_MainMenu():
	$MainMenu/BG.hide()
	$MainMenu/Context1.hide()
	for but in $MainMenu/Buttons.get_children():
		but.disabled = true
		but.visible = false
		
func display_MainMenu():
	$MainMenu/BG.hide()
	$MainMenu/Context1.hide()
	for but in $MainMenu/Buttons.get_children():
		but.disabled = false
		but.visible = true

func hide_EndMenu():
	$EndMenu/TextureRect.hide()
	$EndMenu/TextureButton.visible = false
	$EndMenu/TextureButton.disabled = true

		
func display_EndMenu():
	$EndMenu/TextureRect.show()
	$EndMenu/TextureButton.visible = true
	$EndMenu/TextureButton.disabled = false
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		display_inGame_menu()
		get_tree().paused = true
		
func prepare_ui(id):
	for i in range(3):
		var drop
	
		drop = TextureRect.new()
		
		drop.texture = load("res://ui/drops_%s.png" % id)
		get_node("PlayersLife/Bar/P%s/HPs" % id).add_child(drop)
	pass

func end_game():
	hide_players_bar()
	pass	

func start_game():
	$MainTheme.play()
	
	prepare_ui(0)
	var p1 = Player.instance()
	p1.id = 0
	p1.position = Vector2(200, 200)
	add_child(p1)
	
	p1.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
	p1.path_pos = $Map/Path2D/PathFollow2D
	
	p1.connect("hit", self, "_on_Player_Hit")
	p1.connect("dead", self, "_on_Player_Dead")
	p1.connect("win", self, "_on_Player_Win")
	
	
	if TWO_PLAYERS:
		var p2 = Player.instance()
		p2.id = 1
		p2.position = Vector2(64, 128)
		add_child(p2)
		p2.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
		p2.path_pos = $Map/Path2D/PathFollow2D
		
		prepare_ui(1)
	
	
	for button in $MainMenu/Buttons.get_children():
		button.disabled = true
		button.visible = false
		
	$MainMenu/BG.hide()
	$MainMenu/Context1.show()
	nb_dead = 0
	$Map.init()
	yield(get_tree().create_timer(2), "timeout")
	
	$MainMenu/Context1.hide()
	display_players_bar()
	
	$Map.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/Context1.hide()
	hide_inGame_menu()
	hide_players_bar()
	hide_EndMenu()


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
	

var nb_dead = 0
func _on_Player_Dead(id):
	var tot_players = 1
	print("A PLAYER IS DEAD")
	nb_dead +=1
	if TWO_PLAYERS:
		tot_players = 2
		
	if nb_dead == tot_players:
		$EndMenu/TextureRect.texture = load("res://ui/gameOvaire_screen.png")
		display_EndMenu()
		
func _on_Player_Win(id):
	$EndMenu/TextureRect.texture = load("res://ui/winP%s_screen.png" % id)
	display_EndMenu()
	
func _on_Player_Hit(id):
#	if get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0).queue_free()
	if get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0):
		get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0).queue_free()


func _on_TextureButton_pressed():
	hide_EndMenu()
	hide_players_bar()
	display_MainMenu()
	pass # Replace with function body.
