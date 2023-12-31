extends Area2D

var screensize = Vector2()

func _ready():
	$AnimationTimer.wait_time = rand_range(0.2,0.5)
	$AnimationTimer.start()
	$Tween.interpolate_property($AnimatedSprite,'scale',
		$AnimatedSprite.scale,
		$AnimatedSprite.scale*3,
		.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite,'modulate',
		Color(1,1,1,1),
		Color(1,1,1,0),
		.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)


func pickup():
	set_deferred("monitorable", false) 
	$Tween.start()


func _on_Tween_tween_completed(_object, _key):
	queue_free()


func _on_Timer_timeout():
	queue_free()


func _on_AnimationTimer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
