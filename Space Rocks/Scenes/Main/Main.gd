extends Node

#---received signals---
func _on_Player_shoot(bullet, pos, dir):
	var b = bullet.instance()
	b.start(pos,dir)
	add_child(b)
#/---received signals---
