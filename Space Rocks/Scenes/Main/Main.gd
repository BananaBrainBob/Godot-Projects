extends Node

export (PackedScene) var Rock
export (PackedScene) var Enemy 

var screensize : Vector2
var level : int = 0
var score : int = 0
var playing : bool = false

func _ready() -> void:
	var msg = JavaScript.eval("msg")
	print(typeof(msg))
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	#for _i in range(3):
	#	spawn_rock(3)

func _process(_delta:float) -> void:
	if playing and $Rocks.get_child_count() == 0:
		new_level()

func new_game() -> void:
	for rock in $Rocks.get_children():
		rock.queue_free()
	level = 0
	score = 0
	$HUD.update_score(score)
	$Player.start()
	$HUD.show_message("Get Ready!")
	yield($HUD/MessageTimer,"timeout")
	playing = true
	new_level()

func new_level() -> void:
	level += 1
	$HUD.show_message("Wave %s"% level)
	for _i in range(level):
		spawn_rock(3)
	$EnemyTimer.wait_time = rand_range(5,10)
	$EnemyTimer.start()

func game_over() -> void:
	playing = false
	$HUD.game_over()

func spawn_rock(size:float,pos= null, vel = null) -> void:
	if !pos:
		$RockPath/RockSpawn.set_offset(randi())
		pos = $RockPath/RockSpawn.position
	if !vel:
		vel = Vector2(1,0).rotated(rand_range(0,2*PI))* rand_range(100,150)
	var r = Rock.instance()
	r.screensize = screensize
	r.start(pos,vel,size)
	$Rocks.add_child(r)
	r.connect("exploded",self,"_on_rock_exploded")

func _on_rock_exploded(size:float, radius:float, pos:Vector2, vel:Vector2) -> void:
	if size <= 1:
		return
	for offset in [-1,1]:
		var dir = (pos - $Player.position).normalized().tangent() * offset
		var newpos = pos+ dir* radius
		var newvel = dir*vel.length() * 1.1
		spawn_rock(size-1,newpos,newvel)

func _on_Player_shoot(bullet:PackedScene, pos:Vector2, dir:float) -> void:
	var b = bullet.instance()
	b.start(pos,dir)
	add_child(b)

func _input(event : InputEvent):
	
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if event.is_action_pressed("pause"):
		if not playing:
			return
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			$HUD/MessageLabel.text = "Paused"
			$HUD/MessageLabel.show()
		else:
			$HUD/MessageLabel.text = ""
			$HUD/MessageLabel.hide()


func _on_EnemyTimer_timeout():
	print("Creating Enemy")
	var e = Enemy.instance()
	add_child(e)
	e.target = $Player
	e.connect("shoot",self,"_on_Player_shoot")
	$EnemyTimer.wait_time = rand_range(20,40)
	$EnemyTimer.start()
