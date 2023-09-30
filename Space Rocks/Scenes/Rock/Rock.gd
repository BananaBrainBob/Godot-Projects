extends RigidBody2D

## An asteroid script
##
## Uses physics to move around
##

signal exploded

#---variables---
var screensize : Vector2
var size : float
var radius : float
export var scale_factor : float = 0.2
#/---variables---

#---custom funcs---
func start(pos:Vector2 ,vel :Vector2, _size :float):
	position = pos
	size =_size
	mass = 1.5*size
	$Sprite.scale = Vector2(1,1) * scale_factor * size
	radius = int($Sprite.texture.get_size().x/2 *scale_factor *size)
	var shape := CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.set_deferred("shape",shape)
	linear_velocity = vel
	angular_velocity = rand_range(-1.5,1.5)
	$Explosion.scale = Vector2(0.75,0.75) * size
	
#/---custom funcs---
func explode():
	$CollisionShape2D.set_deferred("Disabled",true)
	layers = 0
	$Sprite.hide()
	$Explosion/AnimationPlayer.play("Explosion")
	emit_signal("exploded",size,radius,position,linear_velocity)
	linear_velocity = Vector2()
	angular_velocity = 0
	
func _integrate_forces(physics_state : Physics2DDirectBodyState):
	var xform = physics_state.get_transform() as Transform2D
	if xform.origin.x > screensize.x + radius:
		xform.origin.x = 0 -radius
	if xform.origin.x < 0 - radius:
		xform.origin.x = screensize.x + radius
	if xform.origin.y > screensize.y + radius:
		xform.origin.y = 0 -radius
	if xform.origin.y < 0 - radius:
		xform.origin.y = screensize.y + radius
	physics_state.set_transform(xform)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
