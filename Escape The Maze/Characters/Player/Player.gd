extends "res://Characters/Parent/Character.gd"

signal moved
signal dead
signal grabbed_key
signal win

func _ready():
	$Sprite.scale = Vector2(1,1)

func _process(_delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				if move(dir):
					$FootstepsSound.play()
					emit_signal('moved')


func _on_Player_area_entered(area):
	if area.is_in_group('enemies'):
		area.hide()
		set_process(false)
		$CollisionShape2D.set_deferred("Disabled",true)
		$LoseSound.play()
		$AnimationPlayer.play("die")
		yield($LoseSound, "finished")
		emit_signal('dead')
		
	if area.has_method('pickup'):
		area.pickup()
		if area.type == 'key_red':
			emit_signal('grabbed_key')
		if area.type == 'star':
			$WinSound.play()
			$CollisionShape2D.set_deferred("Disabled",true)
			yield($WinSound,"finished")
			emit_signal('win')
