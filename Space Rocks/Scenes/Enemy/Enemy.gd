extends Area2D

signal shoot

export (PackedScene) var bullet
export (int) var speed = 10
export (int) var health = 3 

var follow : PathFollow2D
var target = null

func _ready():
	$Sprite.frame = randi() % 3
	var path = $EmptyPathes.get_children()[randi() % $EmptyPathes.get_child_count()]
	follow = PathFollow2D.new()
	path.add_child(follow)
	follow.loop = false

func _process(delta):
	follow.offset += speed * delta
	position = follow.global_position
	if follow.unit_offset > 1:
		queue_free()

func shoot():
	var dir = target.global_position - global_position
	dir = dir.rotated(rand_range(-0.1,0.1)).angle()
	emit_signal("shoot",bullet,global_position,dir)

func shoot_pulse(n, delay):
	for _i in range(n):
		shoot()
		yield(get_tree().create_timer(delay),"timeout")

func take_damage(amount):
	health -= amount
	$AnimationPlayer.play("Flash")
	if health <= 0:
		explode()
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Rotate")
	
func explode():
	speed = 0
	$GunTimer.stop()
	$CollisionShape2D.set_deferred("disabled",true)
	$Sprite.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("Explosion")
	$ExplodeSound.play()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func _on_GunTimer_timeout():
	shoot_pulse(3,0.15)


func _on_Enemy_body_entered(body:Node):
	if body.name == "Player":
		pass
	explode()
