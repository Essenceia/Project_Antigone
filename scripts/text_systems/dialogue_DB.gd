extends Node

# Singelton class that set's what dialogue can be played in a given context

var d_names       : PoolStringArray
var d_repleatable : PoolIntArray
var d_passive     : PoolIntArray
var d_played      : PoolIntArray
var d_id          : PoolIntArray
var d_cond_loc    : Dictionary
var d_cond_chara  : Dictionary
var d_cond_flags  : Dictionary
var d_proba : Array
var db_size       : int

func _init():
	db_size = 0
	# copy the contents of the db
	set_db(0,"intro",0,0,0.0,[1],[0],[])

func set_db(var id : int, var name : String, var repeatable : bool , var passive : bool, var proba : float, var loc : PoolIntArray, var  chara : PoolIntArray , var flags : PoolStringArray):
	db_size += 1
	d_names.append(name)
	d_repleatable.append(repeatable)
	d_passive.append(passive)
	d_proba.append(proba)
	d_played.append(0)
	d_id.append(id)
	d_cond_loc[id]   = loc
	d_cond_chara[id] = chara
	d_cond_flags[id] = flags
	
func _ready():
	pass # Replace with function body.

func set_triggered(var db_id: int):
	d_played[db_id] += 1


func get_dialogue_name(var db_id : int):
	return d_names[db_id]

func get_dialogue_proba(var db_id : int):
	return d_proba[db_id]
	
func get_dialogue_is_passive(var db_id : int):
	return d_passive[db_id]

# try to find another dialogue fitting the conditions, if no dialogue matches return -1
func get_next_dialogue_id(var start_id : int, var loc : int, var  chara : PoolIntArray , var flags : PoolStringArray) -> int:
	var found : bool
	found = false
	start_id = 0 if start_id < 0 else start_id  
	for i in range(start_id,db_size,1):
		# start by looking at all dialogues that match our location
		if loc in d_cond_loc[i]:
			# look if is repeatable or has never been played yet
			if (d_repleatable[i] == 1 ) || ( d_repleatable[i] == 0 && d_played[i] == 0 ):
				# look at characters present
				if chara in d_cond_chara[i]:
					# look at if flags are met :
					if d_cond_flags[i].empty():
						found = true
					else :
						if flags in d_cond_flags[i]:
							found = true
		if found == true :
			return i
	return -2
