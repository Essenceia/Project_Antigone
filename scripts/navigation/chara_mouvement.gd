extends Sprite

# wait 10 seconds before going to the next node
const nav_speed : float = 0.50

var pos_str : String
var navigator : Node2D
var mvm_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	mvm_timer = get_node("mvm_timer")
	mvm_timer.autostart = false
	mvm_timer.one_shot  = true

func link(var nav : Node2D):
	navigator = nav

func set_start_pos(var npos : String):
	_set_pos(npos)

func _set_pos(var npos : String):
	var pos_v2
	pos_str = npos
	pos_v2 = navigator.get_pos_from_str(pos_str)
	self.set_position(pos_v2)
	print("New position moved to "+String(pos_v2))

func nav_to_pos(var npos : String):
	var traj : PoolStringArray
	var start_pos : String
	
	start_pos = pos_str
	traj = navigator.get_path_to_pos(start_pos, npos)
	traj.remove(0) # remove start pos, we are already there
	for ipos in traj:
		mvm_timer.start(nav_speed)
		yield(mvm_timer, "timeout")
		_set_pos(ipos)
		
func get_pos()-> String:
	return pos_str

