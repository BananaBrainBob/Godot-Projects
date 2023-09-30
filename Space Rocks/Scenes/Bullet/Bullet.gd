extends Area2D

export (int) var speed = 1000

var velocity := Vector2()

func _process(delta : float) -> void:
	position += velocity * delta

func start(pos:Vector2, dir:float):
	position = pos
	rotation = dir
	velocity = Vector2(speed,0).rotated(dir)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body : Object):
	if body.is_in_group("rocks"):
		body.explode()
		queue_free()
