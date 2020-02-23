extends KinematicBody2D

signal use

signal dead

signal hit

const DIE = true

export var BASE_FRICTION = 0.07
var STOP_FRICTION = 0.5

export var curent_anim = "idle"
export var max_speed = 800

var isSpeedModified = false
var modifiedSpeed = 0

export var friction = 0.07
export var friction_delta = 0.0002
export var acceleration = 0.1

const BASE_ACCEL = 0.3
const DASH_ACCEL = 0.4

const BASE_SPEED = 800
const DASH_SPEED = 1000

const SLOW_SPEED = 400

const BASE_HP = 3
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
var game_camera

# ref to the game zone area to clamp the pos
var game_zone: Area2D
var path_pos

var bouncing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	dead = false
	pass


func clamp_to_zone():
	
#	var kek = get_parent().get_node()

	var area_size = game_zone.get_node("CollisionShape2D").shape.extents
	
	
	position.x = clamp(position.x, path_pos.position.x - area_size.x , path_pos.position.x + area_size.x)
	position.y = clamp(position.y, path_pos.position.y - area_size.y, path_pos.position.y + area_size.y)


func _physics_process(delta):
	
	if dead:
		return
	
	max_speed = BASE_SPEED
	acceleration = BASE_ACCEL
	friction = BASE_FRICTION

	input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left_%s" % id):
		input_velocity.x -= 1
	if Input.is_action_pressed("ui_right_%s" % id):
		input_velocity.x += 1
	if Input.is_action_pressed("ui_up_%s" % id):
		input_velocity.y -= 1
	if Input.is_action_pressed("ui_down_%s" % id):
		input_velocity.y += 1
	
	if isSpeedModified:
		max_speed = modifiedSpeed
		
	input_velocity = input_velocity.normalized() * max_speed
	
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		if velocity.length() != 0:
			velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	
	if !bouncing:
		velocity = move_and_slide(velocity)
		
	if get_slide_count() != 0:
			if get_slide_collision(0).collider.is_in_group("tiles"):
				if not slowing:
					slow_down()
#			elif get_slide_collision(0).collider.is_in_group("player"):
#				print("COLLIDE PLAYERS")
#				bouncing = true
#				velocity = velocity.bounce(get_slide_collision(0).normal)
#				yield(get_tree().create_timer(2), "timeout")
#				bouncing = false
				
					
	
	clamp_to_zone()

func _process(delta):
	if input_velocity.x != 0:
		if input_velocity.x < 0:
			$Sprite.scale.x = -1
		else:
			$Sprite.scale.x = 1
	

func slow_down():
	applySpeed(-400, 2)
	


var taking_dmg = false

func take_damage(amount):
	
	if not taking_dmg:
		if hp-amount <= 0:
			die()
		emit_signal("hit", id)
		taking_dmg = true
		set_hp(hp-amount)
		make_invincible()
		$HurtSound.play()
		$HurtSound.stop()
		
		
func set_hp(new_hp):
	if (new_hp > BASE_HP or new_hp < 0):
		return
	print("HP CHANGING TO ", new_hp)
	hp = new_hp

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
		emit_signal("dead", id)
		queue_free()
		
func applySpeed(speed, timer):
	modifiedSpeed = BASE_SPEED + speed

	isSpeedModified = true
	yield(get_tree().create_timer(timer), "timeout")
	isSpeedModified = false
