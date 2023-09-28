extends RigidBody2D

var screensize := Vector2()
var size
var radius
var scale_factor


func start(pos, vel, _size):
	position = pos
	size =_size
	mass = 1.5*size
	$Sprite.scale = Vector2(1,1) * scale_factor * size
	radius = int($Sprite.texture.get_size().x/2 *scale_factor *size)
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape
	linear_velocity = vel
	angular_velocity = rand_range(-1.5,1.5)

func _integrate_forces(physics_state : Physics2DDirectBodyState) -> void:	
	var xform := physics_state.get_transform() as Transform2D
	
	if xform.origin.x > screensize.x + radius:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x + radius
	if xform.origin.y > screensize.y + radius:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y + radius
	physics_state.set_transform(xform)
