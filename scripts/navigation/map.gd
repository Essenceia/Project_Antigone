extends Node

# name -> astart id
var pos_name_to_id       : Dictionary
var pos_id_to_name       : Dictionary

var astar : AStar2D

func _ready():
	var tmp_sprite     : Sprite
	var tmp_sprite_str : String
	var tmp_pos        : Vector2
	var self_path_str  : String
	var i : int 
	i = 0
	astar = AStar2D.new()
	self_path_str = self.get_path()
	# get postiontions of every sprite on the map 
	for n in self.get_children():
		tmp_sprite = n
		tmp_sprite_str = n.get_path()
		tmp_sprite_str = tmp_sprite_str.replace(self_path_str+"/","")
		tmp_pos = n.get_position();
		astar.add_point(i,tmp_pos)
		pos_name_to_id[tmp_sprite_str] = i
		pos_id_to_name[i] = tmp_sprite_str
		i += 1

# create the connectios between points to be used in the astart graph
func create_connections():
	# init room
	con("P001","P002")
	con("P002","P003")
	con("P002","P004")
	con("P002","D000")
	con("P003","D000")
	con("P004","D000")
	con("D000","P092")
	# living quarter hallway
	con("P092","P091")
	con("P092","P093")
	con("P093","P094")
	con("P094","P095")
	
	# hallway leading up to single door room 
	con("D010","P093")
	con("D020","P093")
	con("D020","P093")
	con("D030","P095")
	con("D040","P091")
	con("D050","P092")
	con("D060","P092")
	con("D070","P093")
	# single door rooms
	for c in ["01","03","05","06","07"]:
		con("D"+c+"0","P"+c+"1")
	# room 021, it's special as it has more than one location
	con("P021","P022")
	con("P022","P023")

# get name of all positions on the path between 2 postions
func get_path_to_pos(var start_pos : String, var end_pos) -> PoolStringArray:
	var pos1_id  : int
	var pos2_id  : int
	var path_id  : PoolIntArray
	var path_str : PoolStringArray
	
	path_str = []
	# check if pos exists
	pos_exists(start_pos)
	pos_exists(end_pos)
	
	pos1_id = pos_name_to_id[start_pos]
	pos2_id = pos_name_to_id[end_pos]
	
	path_id = astar.get_id_path(pos1_id, pos2_id)
	
	for i in path_id:
		path_str.push_back(pos_id_to_name[i])

	return path_str

# short for connect 2 positions
func con(var pos1 : String, var pos2 : String):
	var i1 : int
	var i2 : int
	i1 = -1
	i2 = -1
	if (pos_name_to_id.has(pos1)):
		i1 = pos_name_to_id[pos1]
	else:
		assert(false)
	if (pos_name_to_id.has(pos2)):
		i2 = pos_name_to_id[pos2]
	else:
		assert(false)
	astar.connect_points(i1,i2,true)

func pos_exists(var pos : String):
	if (!pos_name_to_id.has(pos)):
		print("Error : pos not found, check spelling : "+ pos)
		assert(false)
func get_pos_from_str(var pos: String)-> Vector2:
	var id : int
	pos_exists(pos)
	id = pos_name_to_id[pos]
	return astar.get_point_position(id)
