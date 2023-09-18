extends Node

export (PackedScene) var coin
export (PackedScene) var powerup
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize =  screensize
	$Player.hide()

func _process(_delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		$HUD.update_timer(time_left)
		$PowerupTimer.stop()
		$PowerupTimer.wait_time = rand_range(3.0,8.0)
		$PowerupTimer.start()
		spawn_coins()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$PowerupTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

	
func spawn_coins():
	for _i in range(4 + level):
		var c = coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(
			rand_range(0,screensize.x),
			rand_range(0,screensize.y))
	$Audio/LevelSound.play()


func _on_GameTimer_timeout():
	time_left -=1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()
		
func game_over():
	playing = false
	$GameTimer.stop()
	$PowerupTimer.stop()
	for coin_child in $CoinContainer.get_children():
		coin_child.queue_free()
	$HUD.show_game_over()
	$Player.die()


func _on_Player_hurt():
	game_over()
	$Audio/EndSound.play()

func _on_Player_pickup():
	score += 1
	$HUD.update_score(score)
	$Audio/CoinSound.play()


func _on_Player_powerup():
	time_left += 5
	$HUD.update_timer(time_left)
	$Audio/PowerupSound.play()

func _on_PowerupTimer_timeout():
	if not playing:
		return
	var p = powerup.instance()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(
		rand_range(0,screensize.x),
		rand_range(0,screensize.y))
	
