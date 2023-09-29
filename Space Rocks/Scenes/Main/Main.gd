extends Node

export (PackedScene) var rock

var screensize : Vector2

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	for _i in range(3):
		spawn_rock(3)

func spawn_rock(size:float,pos= null, vel = null):
	if pos == null:
		$RockPath/RockSpawn.set_offset(randi())
		pos = $RockPath/RockSpawn.position
	if vel == null:
		vel = Vector2(1,0).rotated(rand_range(0,2*PI))* rand_range(100,150)
	var r = rock.instance()
	r.screensize = screensize
	r.start(pos,vel,size)
	$Rocks.add_child(r)

#---received signals---
func _on_Player_shoot(bullet, pos, dir):
	var b = bullet.instance()
	b.start(pos,dir)
	add_child(b)
#/---received signals---

