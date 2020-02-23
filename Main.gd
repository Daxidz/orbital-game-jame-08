extends Node

const TWO_PLAYERS = true

var Player = preload("res://player/Player.tscn")

var cur_img

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if cur_img:
			cur_img.hide()
			enable_MainButtons()
			pass

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
		
func disable_MainButtons():
	for but in $MainMenu/Buttons.get_children():
		but.disabled = true
		but.visible = false
func enable_MainButtons():
	for but in $MainMenu/Buttons.get_children():
		but.disabled = false
		but.visible = true
	
func hide_MainMenu():
	$MainMenu/BG.hide()
	$MainMenu/Infos.hide()
	for but in $MainMenu/Buttons.get_children():
		but.disabled = true
		but.visible = false
		
func display_MainMenu():
	$MainMenu/BG.show()
	$MainMenu/Infos.hide()
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
		
func prepare_ui(id):
	for i in range(3):
		var drop
	
		drop = TextureRect.new()
		
		drop.texture = load("res://ui/drops_%s.png" % id)
		get_node("PlayersLife/Bar/P%s/HPs" % id).add_child(drop)
		print("Remove life %s" % id)
	pass

func end_game():
	hide_players_bar()
	for child in get_children():
		if child.is_in_group("player"):
			child.queue_free()
			
	for life in $PlayersLife/Bar/P0/HPs.get_children():
		life.free()
	
	for life in $PlayersLife/Bar/P1/HPs.get_children():
		life.free()	

var p1
var p2

func start_game():
	$MainTheme.play()
	prepare_ui(0)
	p1 = Player.instance()
	p1.id = 0
	p1.position = Vector2(64, 200)
	add_child(p1)
	
	p1.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
	p1.path_pos = $Map/Path2D/PathFollow2D
	
	p1.connect("hit", self, "_on_Player_Hit")
	p1.connect("dead", self, "_on_Player_Dead")
	p1.connect("win", self, "_on_Player_Win")
	
	if TWO_PLAYERS:
		p2 = Player.instance()
		p2.id = 1
		p2.position = Vector2(64, 128)
		add_child(p2)
		p2.game_zone = $Map/Path2D/PathFollow2D/Camera2D/Area2D
		p2.path_pos = $Map/Path2D/PathFollow2D
		
		prepare_ui(1)
		p2.connect("hit", self, "_on_Player_Hit")
		p2.connect("dead", self, "_on_Player_Dead")
		p2.connect("win", self, "_on_Player_Win")
	
	
	for button in $MainMenu/Buttons.get_children():
		button.disabled = true
		button.visible = false
		
	$MainMenu/BG.hide()
	nb_dead = 0
	$Map.init()
	yield(get_tree().create_timer(1.5), "timeout")
	
	display_players_bar()
	
	$Map.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/Infos.hide()
	$MainMenu/Controls.hide()
	$MainMenu/Infos.hide()
	$MainMenu/Credits.hide()
	
	hide_inGame_menu()
	hide_players_bar()
	hide_EndMenu()


func _on_StartButton_pressed():
	start_game()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	hide_inGame_menu()
	get_tree().paused = false
	

var nb_dead = 0
func _on_Player_Dead(id):
	var tot_players = 1
	nb_dead +=1
	if TWO_PLAYERS:
		tot_players = 2
		
	if nb_dead == tot_players:
		$EndMenu/TextureRect.texture = load("res://ui/gameOvaire_screen.png")
		display_EndMenu()
		
func _on_Player_Win(id):
	$EndMenu/TextureRect.texture = load("res://ui/winP%s_screen.png" % id)
	display_EndMenu()
	end_game()
	
func _on_Player_Hit(id):
#	if get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0).queue_free()
	if get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0):
		get_node("PlayersLife/Bar/P%s/HPs" % id).get_child(0).queue_free()


func _on_TextureButton_pressed():
	hide_EndMenu()
	hide_players_bar()
	display_MainMenu()


func _on_InfoButton_pressed():
	cur_img = $MainMenu/Infos
	cur_img.show()
	disable_MainButtons()
	

func _on_Credits_pressed():
	cur_img = $MainMenu/Credits
	cur_img.show()
	disable_MainButtons()


func _on_Controls_pressed():
	cur_img = $MainMenu/Controls
	cur_img.show()
	disable_MainButtons()


