extends Node

enum MAP_DIC {
	AIRLOCK = 1,
	CRACKS = 2,
	FILTRATION = 3,
	MAINFRAME = 4,
	MONITOR = 5,
	STIRLING = 6,
	WALLS = 7,
	WATER_SHIELD = 8,
	WATER_STORAGE = 9,
	HEAVY_DOOR = 10,
	ROOM_DOOR = 11,
	SEPARATORS = 12,
	VENTS_VERTICAL = 13,
	PLANTS = 14,
	PONIC_WALLS = 15,
	SEDIMENT_TANK = 16,
	WETLAND = 17,
	VENTS_CEILING = 18
	}
var map_dic_bmp : Dictionary
var sound_dic   : Dictionary
var astart      : AStar2D


var player_pos  : Vector2
var map_outline : NavigationPolygon
var path_finder : Navigation2D

var map_size_x  : int
var map_size_y  : int
# Called when the node enters the scene tree for the first time.

func _ready():


	var tmp_size_v2 : Vector2


	astart   = AStar2D.new()

#	creat_map_from_file(1,"Airlocks")
#	creat_map_from_file(2,"Cracks")
#	creat_map_from_file(3,"Filtration-recirculation")
#	creat_map_from_file(4,"Mainframe")
#	creat_map_from_file(5,"Monitors-etc")
#	creat_map_from_file(6,"Stirlings")
#	creat_map_from_file(7,"Walls")
#	creat_map_from_file(8,"Water-shield")
#	creat_map_from_file(9,"Water-storage")
#	creat_map_from_file(10,"Heavy-doors")
#	creat_map_from_file(11,"Room-doors")
#	creat_map_from_file(12,"Separators")
#	creat_map_from_file(13,"Vents-vertical")
#	creat_map_from_file(14,"Plants")
#	creat_map_from_file(15,"Ponic-walls")
#	creat_map_from_file(16,"Sediment-tank")
#	creat_map_from_file(17,"Wetland")
#	creat_map_from_file(18,"Vents-ceiling")
#
#	tmp_size_v2 = map_dic_bmp[MAP_DIC.WALLS].get_size()
#	map_size_x  = tmp_size_v2.x
#	map_size_y  = tmp_size_v2.y
#
#	# sound map
#	#sound_dic[MAP_DIC.S_SEL3] = Sound.new()
#	#sound_dic[MAP_DIC.S_SEL3].start(MAP_DIC.S_SEL3, true)
#	for i in range(1,19,1):
#		_debug_store_bmp_map(i,String(i))
#
#	#init_astart()
#
#	# set player start pos
#	player_pos = Vector2(1,1)

func creat_map_from_file(var key : int, var fname : String):
	var map_img : Image
	map_img           = Image.new()
	map_dic_bmp[key]  = BitMap.new()
	var err  = map_img.load("res://map/"+fname+".png")
	if ( err != OK ):
		print("Error opening image to create map")
		assert(false)
	map_dic_bmp[key].create_from_image_alpha( map_img , 0.1 )
# get the list of sounds within a given range
# return format : ( sound_id, distance )
func get_sound(var radius : int ,var start_pos : Vector2):
	var retval_pv3   : PoolVector3Array
	var sound_keys   : Array
	var s_found_v2   : PoolVector2Array
	var rng_poolint  : PoolIntArray
	var path_poolint : PoolIntArray
	var upper_bound  : int
	
	rng_poolint = get_range_in_map(start_pos, radius)
	sound_keys = sound_dic.keys()
	for key in sound_keys:
		s_found_v2 = naive_depth_first_search(rng_poolint, key, sound_dic[key].traversible)
		if (!s_found_v2.empty()):
			# found a sound source within radius
			# check if the sound is traversable
			if (sound_dic[key].traversible == true):
				# call sound manager to produce a sound
				print("TODO")
				assert(false)
			else :
				# check if there exists a path between player pos and at least one sounds source
				# TODO upper bound
				upper_bound = s_found_v2.size() if s_found_v2.size() < 4 else 4
				for i in range(upper_bound):
					path_poolint = astart.get_id_path(pos_v2_to_id(start_pos),pos_v2_to_id(s_found_v2[i]))
					if (!path_poolint.empty()):
						# one path has been found
						# call sound manager with distance path_poolint.size()
						print("TODO")
						assert(false)
						break
	
func init_astart():
	var wall_map_copy : BitMap
	var tmp_pos_v2    : Vector2
	var map_size_v2   : Vector2
	var tmp_b         : bool
	var point_id      : int
	var to_point_id   : int
	
	wall_map_copy = map_dic_bmp[MAP_DIC.OUTLINE]
	map_size_v2   = wall_map_copy.get_size()
	point_id      = 0
	# start building from 0,0
	# start by creating all points
	for y in range(0.0,map_size_v2.y,1.0):
		for x in range(0.0,map_size_v2.x,1.0):
			tmp_pos_v2 = Vector2(x,y)
			tmp_b      = wall_map_copy.get_bit(tmp_pos_v2)
			if(tmp_b == false): # not a wall
				astart.add_point(point_id,tmp_pos_v2,1.0)
			point_id += 1
	# connect all points
	point_id = 0
	for y in range(0.0,map_size_v2.y,1.0):
		for x in range(0.0,map_size_v2.x,1.0):
			tmp_pos_v2 = Vector2(x,y)
			tmp_b      = wall_map_copy.get_bit(tmp_pos_v2)
			if(tmp_b == false): # not a wall, look at neighbors
				for e in [Vector2(0.0, 1.0),Vector2(1.0,0.0)]:
						if ( e.x + x < map_size_v2.x && e.y + y < map_size_v2.y):
							tmp_b = wall_map_copy.get_bit(Vector2(x+e.x,y+e.y))
							if (tmp_b == false): # also not a wall
								to_point_id = ( x + e.x ) + ( map_size_v2.x * (y + e.y))
								astart.connect_points(point_id, to_point_id, true)
			point_id += 1
# for traversable sounds
# map_dic_key : type of map we are looking at
func naive_depth_first_search(var rng_poolint : PoolIntArray , var map_dic_key : int, var first_only : bool ) -> PoolVector2Array:
	var line_str    : String
	var ret_poolv2  : PoolVector2Array
	var found_b     : bool
	var tmp_v2      : Vector2
	
	for  y in range(rng_poolint[2],rng_poolint[3],1):
		for x in range(rng_poolint[0],rng_poolint[1],1):
			tmp_v2  = Vector2(float(x),float(y))
			found_b = map_dic_bmp[map_dic_key].get_bit(tmp_v2)
			if (found_b == true):
				ret_poolv2.push_back(tmp_v2)
				if (first_only == true):
					break
	
	return ret_poolv2

# return positions in array : [ min_x , max_x , min_y , max_y ]
func get_range_in_map(var start_pos : Vector2, var radius : int)-> PoolIntArray :
	var tmp_size_v2 : Vector2
	var rng_min_x   : int
	var rng_min_y   : int
	var rng_max_x   : int
	var rng_max_y   : int
	var tmp_i       : int
	var ret_poolint : PoolIntArray

	tmp_size_v2 = map_dic_bmp[MAP_DIC].get_size()
	
	tmp_i       = start_pos.x - radius
	rng_min_x   = tmp_i if tmp_i > 0 else start_pos.x
	tmp_i       = start_pos.y - radius
	rng_min_y   = tmp_i if tmp_i > 0 else start_pos.y
	tmp_i       = start_pos.x + radius
	rng_max_x   = tmp_i if tmp_i < tmp_size_v2.x else tmp_size_v2.x
	tmp_i       = start_pos.y + radius
	rng_max_y   = tmp_i if tmp_i < tmp_size_v2.y else tmp_size_v2.y
	
	ret_poolint.push_back(rng_min_x)
	ret_poolint.push_back(rng_max_x)
	ret_poolint.push_back(rng_min_y)
	ret_poolint.push_back(rng_max_y)
	return ret_poolint

func _debug_show_bmp_map(var map_key : int):
	var current     : bool
	var line_str    : String

	for  y in range(0,map_size_y,1):
		for x in range(0, map_size_x,1):
			line_str += "1" if map_dic_bmp[MAP_DIC.OUTLINE].get_bit(Vector2(float(x),float(y))) else "0"
		line_str += "\n"
	save(line_str,"0")
	
func _debug_store_bmp_map(var map_key : int, var fname : String):
	var current     : bool
	var line_str    : String
	
	line_str = "u8 bmp_"+String(map_key)+" = {"
	for  y in range(0,map_size_y,1):
		for x in range(0, map_size_x,1):
			line_str += "1," if map_dic_bmp[map_key].get_bit(Vector2(float(x),float(y))) else "0,"
		line_str[line_str.length()-1] = " "
		line_str += "};"
	save(line_str,String(map_key))
	
func save(var content: String, var fname : String ):
	var file : File
	var path : String
	var err 
	file = File.new()
	path = "res://save/"+fname+".h"
	print("Writing to file "+path)
	err = file.open(path, File.WRITE)
	if (!file.is_open() || err!= OK) :
		print("file error "+String(err))
		assert(false)
	file.store_string(content)
	file.close()

func pos_v2_to_id(var pos : Vector2) -> int:
	return int(pos.x) + ( map_size_x * int(pos.y) )

