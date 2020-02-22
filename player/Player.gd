extends KinematicBody2D

signal use

const DIE = false

export var BASE_FRICTION = 0.07
var STOP_FRICTION = 0.5

export var curent_anim = "idle"
export var max_speed = 800

export var friction = 0.07
export var friction_delta = 0.0002
export var acceleration = 0.1

const BASE_ACCEL = 0.3
const DASH_ACCEL = 0.4

const BASE_SPEED = 800
const DASH_SPEED = 1000

const SLOW_SPEED = 400

const BASE_HP = 4
var hp = BASE_HP 
var dead

onready var anim_player = get_node("AnimationPlayer")

var attacking = false
var end_attack = false
var dashing = false

var slowing = false

var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO


var id

enum STATES { IDLE, MOVING, DASHING, ATTACKING, TOUCHED } 

var state = "idle"


# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("idle")
	dead = false
	pass
	 


func _physics_process(delta):
	
	if dead:
		return
	
	max_speed = BASE_SPEED
	acceleration = BASE_ACCEL
	friction = BASE_FRICTION

	input_velocity = Vector2.ZERO
	
#		input_velocity.x = Input.get_action_strength("ui_right_%s" % id) - Input.get_action_strength("ui_left_%s" % id)
#		input_velocity.y = Input.get_action_strength("ui_down_%s" % id) - Input.get_action_strength("ui_up_%s" % id)
	
	if Input.is_action_pressed("ui_left_%s" % id):
		input_velocity.x -= 1
	if Input.is_action_pressed("ui_right_%s" % id):

		input_velocity.x += 1
	if Input.is_action_pressed("ui_up_%s" % id):

		input_velocity.y -= 1
	if Input.is_action_pressed("ui_down_%s" % id):
		input_velocity.y += 1

	
	if slowing:
		max_speed = SLOW_SPEED
		
	input_velocity = input_velocity.normalized() * max_speed
	
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		if velocity.length() != 0:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	velocity = move_and_slide(velocity)
	if get_slide_count() != 0:
			if get_slide_collision(0).collider.is_in_group("tiles"):
				if not slowing:
					slow_down()
	

func _process(delta):
	if input_velocity.x != 0:
		if input_velocity.x < 0:
			$Sprite.scale.x = -1
		else:
			$Sprite.scale.x = 1
	pass

func slow_down():
	slowing = true
	yield(get_tree().create_timer(2), "timeout")
	slowing = false
	

func _on_VisibilityNotifier2D_screen_exited():
	print(position)
	
#	get_tree().quit()
	pass # Replace with function body.

var taking_dmg = false

func take_damage(amount):
	
	if not taking_dmg:
		if hp-amount <= 0:
			die()
		taking_dmg = true
		set_hp(hp-amount)
		make_invincible()
		
		
func set_hp(new_hp):
	if (new_hp > BASE_HP or new_hp < 0):
		return
	print("HP CHANGING TO ", new_hp)
	hp = new_hp
	emit_signal("player_hp_change", hp)

func make_invincible():
	$Hitbox.set_deferred("disabled", true);
	flicker(2)
	$Hitbox.set_deferred("disabled", false);

func flicker(time):
	# Flicker 4 times
	for i in time :
		$Sprite.self_modulate.a = 0.1
		yield(get_tree().create_timer(0.25), "timeout")
		$Sprite.self_modulate.a = 1.0
		yield(get_tree().create_timer(0.25), "timeout")
		taking_dmg = false

func die():
	if DIE:
		dead = true
		queue_free()
