extends Node

# Common definitions that will be shared amoung scripts
# Do not bloat this !

const num_chara = 9
# Character list
enum  CHARACTERS {
	Oedipus = 0, Antigone = 1 , Scavenger = 2, Ella = 3, Lakefiled = 4, Watts = 5, Cesear = 6, Doctor = 7, Murderer = 8 , Unamed_m = 9, Unamed_f = 10}
const CHARACTERS_STR : Array = [
	[ "me", "she" , "old man", "other girl", "dude", "guy", "older man", "other guy", "him" , "me" , "???" ],
	[ "Oedipus", "Antigone" , "John Gracey", "Ella Gracey", "Derrick Holmes Lakefield III", "Joan Watts", "Albert ‘Bert’ Cesare", "Doctor", "Luke Iceling" , "me" , "???" ],
	[ "Oedipus", "Antigone" , "John Gracey", "Ella Gracey", "Derrick Holmes Lakefield III", "Joan Watts", "Albert ‘Bert’ Cesare", "Doctor", "Luke Iceling" , "me" , "???" ],
	[ "Oedipus", "Antigone" , "John Gracey", "Ella Gracey", "Derrick Holmes Lakefield III", "Joan Watts", "Albert ‘Bert’ Cesare", "Doctor", "Luke Iceling" , "me" , "???" ]
	]
const CHARACTERS_COLOR : Array = [
	[ "purple", "teal" , "red", "fuchsia", "gray", "silver", "lime", "blue", "maroon" , "black", "black"],
	[ "purple", "teal" , "red", "fuchsia", "gray", "silver", "lime", "blue", "maroon" , "black", "black"],
	[ "purple", "teal" , "red", "fuchsia", "gray", "silver", "lime", "blue", "maroon" , "black", "black"],
	[ "purple", "teal" , "red", "fuchsia", "gray", "silver", "lime", "blue", "maroon" , "black", "black"],
	]
# Text dictionary
var dic : Dictionary = {}

# events triggered
var events : Dictionary = {}
var timers : Dictionary = {}

# characters
var victim : Array

func _init():
	victim = []
	for char_id in CHARACTERS.size():
		# TODO, for the time beeing all of our characters are alive, sorry, no, active, we might want to change that for the shatering
		victim.push_back(Character.new(char_id, true))
		self.add_child(victim[char_id])

	
# Called when the node enters the scene tree for the first time.
func _ready():
	for char_id in CHARACTERS.size():
		victim[char_id].start()
	
	# experiment
	
	pass # Replace with function body.

# character related code
func get_chara_name_bb(var key : int ):
	return victim[key].get_name_bb()

func get_chara_name(var key : int ):
	return victim[key].get_name()
	
func get_standing_grade_with_chara(var key: int):
	return victim[key].get_standing_grade()

func incement_standing_with_chara(var key : int, var x: float, var y: float):
	victim[key].update_standing(x,y)

# event related code
func set_event(var key: String, var val: int):
	if ( !events.has(key)):
		print("Error : unknown event "+ key )
		assert(false)
	else :
		events[key] = val
		print("Event triggered "+ key + " new value "+ String(events[key]))

func get_event(var key : String)-> int:
	if !events.has(key):
		events[key] = 0
	return events[key]

func get_event_pool_str()-> PoolStringArray:
	var ret_pool_str : PoolStringArray
	ret_pool_str = []
	for k in events.keys():
		if events[k] > 0:
			ret_pool_str.push_back(k)
	return ret_pool_str
func test_dictionary():
	pass

func get_dic(var key : String):
	if ( dic.has(key)):
		return dic[key]
	else :
		# in the final version we can override the error and put in a radom text like "..."
		print("Error key not found !")
		assert(false)
		return "..."
	
# global timer management system
func get_timer(var key : String)-> Timer :

	if ( !timers.has(key)):
		# add timer to gloabl list 
		timers[key] = Timer.new()
		self.add_child(timers[key])
	return timers[key]

func set_timer(var key : String, var new_val : float ):
	var tmp_timer : Timer
	tmp_timer = get_timer(key)
	tmp_timer.start(new_val)
