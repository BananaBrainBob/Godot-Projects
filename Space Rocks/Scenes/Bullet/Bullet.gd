extends Area2D

## bullet script
##
## A bullet that traveles in a  straight line until it exits the screen

#---bullet params---
export (int) var speed = 1000
#/---bullet params---

#---calculation params---
var velocity = Vector2()
#/---calculation params---

#---inherited functions---
func _process(delta):
	position += velocity * delta
#/---inherited functions---

#---custom functions---
func start(pos,dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed,0).rotated(dir)
#/---custom functions---

#---received signals---
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if body.is_in_group("rocks"):
		body.explode()
		queue_free()
#/---received signals---
