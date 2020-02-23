#MobSpawner
extends Node2D

const ist1 = preload("res://enemies/IST/IST1/IST1.tscn")
const ist2 = preload("res://enemies/IST/IST2/IST2.tscn")
const ist3 = preload("res://enemies/IST/IST3/IST3.tscn")

const anneau = preload("res://enemies/Contraceptifs/Anneau/Anneau.tscn")
const sterilet = preload("res://enemies/Contraceptifs/Sterilet/Sterilet.tscn")

var mobs = [ist1, ist2, ist3, anneau, sterilet]
export var MAX_AREA = 50

func _ready():
	mobs.shuffle()
	var randomMob = mobs.pop_front()
	var spawn = randomMob.instance()
	spawn.position = getPosition($MobPosition.get_position())
	add_child(spawn)
	pass

func getPosition(posInit):
	randomize()
	var pos = Vector2()
	pos.x = posInit.x + rand_range(-MAX_AREA,MAX_AREA)
	pos.y = posInit.y + rand_range(-MAX_AREA,MAX_AREA)
	return pos
	
