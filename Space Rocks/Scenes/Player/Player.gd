extends RigidBody2D

## The palyer's ship script
##
## Uses a (psudo)state machine to determine the state of the ship
## Input is processed via physics.

#---ship states---
enum States {INIT,ALIVE,INVULNERABLE,DEAD}
var state = null

#---ship engine params---
export (int) var engine_power = 500
export (int) var spin_power = 15000

#---calculation params---
var thrust := Vector2()
var rotation_dir := 0

#---other---
var screensize := Vector2()

#---inherited functions---
func _ready() -> void:
	change_state(States.ALIVE)
	screensize = get_viewport().get_visible_rect().size


func _process(_delta : float) -> void:
	get_input()


func _integrate_forces(physics_state : Physics2DDirectBodyState) -> void:
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power*rotation_dir)
	var xform := physics_state.get_transform() as Transform2D
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screensize.y
	physics_state.set_transform(xform)
	

#---custom functions---
func get_input() -> void:
	thrust = Vector2()
	rotation_dir = 0
	
	if state in [States.DEAD,States.INIT]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_power,0)
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1


func change_state(new_state) -> void:
	match new_state:
		States.INIT:
			$CollisionShape2D.set_deferred("Disabled",true)
		States.ALIVE:
			$CollisionShape2D.set_deferred("Disabled",false)
		States.INVULNERABLE:
			$CollisionShape2D.set_deferred("Disabled",true)
		States.DEAD:
			$CollisionShape2D.set_deferred("Disabled",true)
