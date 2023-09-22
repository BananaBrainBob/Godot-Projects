extends Node

var levels = ["res://Levels/Level1.tscn","res://Levels/Level2.tscn","res://Levels/Level3.tscn"]

var current_level

var start_screen = "res://StartScreen.tscn"
var end_screen = "res://EndScreen.tscn"


var score : int


func new_game():
	score = 0
	current_level = -1
	next_level()

func game_over():
	get_tree().change_scene(end_screen)

func next_level():
	current_level += 1
	if current_level >= Global.levels.size():
		game_over()
	else:
		get_tree().change_scene(levels[current_level])
