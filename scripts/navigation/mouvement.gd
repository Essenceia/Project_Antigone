extends Node2D

# chara_id -> pos_str
var chara_pos : Dictionary

const chara_num : int = 9

var chara_scene = preload("res://scenes/character.tscn")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var tmp_chara
	# creat all characters and attach movement scripts to them
	for i in chara_num:
		tmp_chara = chara_scene.instance()
		chara_pos[i] = tmp_chara
		self.add_child(tmp_chara)

func link(var navigation : Node2D):
	for k in chara_pos.keys():
		chara_pos[k].link(navigation)

# set start positions for character
func set_postion(var char_id : int, var pos: String):
	chara_pos[char_id].set_start_pos(pos)

func get_current_position(var char_id : int)-> String:
	return chara_pos[char_id].get_pos()
func get_characters_in_postion(var pos : String)-> PoolIntArray:
	var ret_pool_i : PoolIntArray
	ret_pool_i = []
	for c in chara_num:
		if get_current_position(c) == pos:
			ret_pool_i.push_back(c)
	return ret_pool_i

func move_to_postion(var char_id : int, var pos : String):
	chara_pos[char_id].nav_to_pos(pos)
