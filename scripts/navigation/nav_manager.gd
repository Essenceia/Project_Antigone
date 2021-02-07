extends Node2D

var pos_n : Node2D
var chara_n : Node2D

func _ready():
	pos_n  = get_node("env/pos")
	chara_n = get_node("env/chara")
	
func start():
	# init connection graph 
	pos_n.create_connections()
	# link nav with characters
	chara_n.link(pos_n)

# set characters to default positions
func init_chara_pos():

	chara_n.set_postion(0,"P001")

	chara_n.move_to_postion(0,"P031")
	print("Init position ended")

func get_current_position(var char_id : int)-> String:
	return chara_n.get_current_position( char_id )
