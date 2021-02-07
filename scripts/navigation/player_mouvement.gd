extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var camera
var me_n

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5



func _ready():
	me_n   = self.get_global_transform()

func move(var mv_dir : Vector2):
	var dir = Vector3()
	var delta = 0.1

	if(mv_dir.x == 0 && mv_dir.y == 1):
		dir += -me_n.basis[2]
	if(mv_dir.x == 0 && mv_dir.y == -1):
		dir+= me_n.basis[2]
	if(mv_dir.x == -1 && mv_dir.y == 0):
		dir += -me_n.basis[0]
	if(mv_dir.x == 1 && mv_dir.y == 0):
		dir += me_n.basis[0]
	dir.y = 0
	dir = dir.normalized()
	velocity.y += delta * gravity
	var hv = velocity
	hv.y = 0
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))	
