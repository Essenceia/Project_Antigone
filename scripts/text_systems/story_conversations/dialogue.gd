extends Node
class_name  dialogue

var cons_o          : Node

var enum_n          : RichTextLabel
var title_n         : Label
var hidden_meta     : Array
var enum_meta       : Array
var char_write_speed : float
var wait_timer       : Timer
var conv_o           : Object
var d_id             : int
var used_meta_a      : Array


func _ready():
	
	cons_o          = get_node("/root/Common")
	wait_timer      = get_node("wait_timer")
	assert(cons_o != null)

	# set a default write speed
	set_char_time(0.01)

	pass # Replace with function body.

func link(var enum_link : RichTextLabel, var title_link : Label, var victime : Object, var id : int):
	enum_n  = enum_link
	conv_o  = victime
	title_n = title_link
	d_id    = id

func set_title( var new_title : String):
	title_n.text = new_title

func clear_text():
	conv_o.clear_text()

func get_event(var event : String)-> int:
	return cons_o.get_event(event)

func set_event(var event : String, var val)-> int:
	return cons_o.set_event(event,val)

func get_id()-> int :
	return d_id

# set the time waited before printing a new character to the screen
func set_char_time(var char_time : float):
	if (char_time <= 0.0):
		print("Error : char time can't be less than zero !")
		assert(false)
	char_write_speed = char_time

# print the text to the screen, additional delay after the end of the sentence
# wait time expressed in seconds
func say_t(var char_id : int, var text : String, var wait : float):
	var line      : String

	line = cons_o.get_chara_name_bb(char_id) + " : " + text + "\n"
	yield(conv_o.dialoge(line,char_write_speed) , "completed")
	if ( wait != 0.0):
		wait_timer.start(wait)
		yield(wait_timer, "timeout") 


func _enum_remove_hidden(var opt : String)-> String:
	var hidden_scope : bool
	var return_str  : String
	return_str   = ""
	hidden_scope = false
	for i in opt:
		match i:
			"[":
				hidden_scope = true
			"]":
				hidden_scope = false
			_ :
				if (hidden_scope == false):
					return_str+=i
	return return_str

func _enum_add_hidden(var opt : String)-> String:
	var return_str  : String
	#while( opt.find("[",0)!= -1 || opt.find("]",0)!= -1):
	opt = opt.replace("[", " ")
	opt = opt.replace("[", " ")
#	opt = opt.replace("{", "[i] ")
#	opt = opt.replace("}", " [/i]")
	return opt

# print enums
# generate a unique meta_id for each enum option
func say_enum(var s_opt : PoolStringArray, var d_opt : PoolStringArray,
			  var d_meta : PoolStringArray) -> int:
	var op_cnt_i     : int
	var rand_i       : int
	var x            : int
	var dyn_idx      : int
	var rand_s       : String
	var meta_clicked : String
	var response_s   : String
	var meta_a       : PoolStringArray
	var enum_s_opt   : PoolStringArray
	var enum_d_opt   : PoolStringArray
	var d_opd_hid    : PoolStringArray
	var d_opd_vis    : PoolStringArray
	
	x = 0
	meta_a     = []
	enum_s_opt = []
	enum_d_opt = []
	
	# generate new unique meta lables
	op_cnt_i = s_opt.size() + d_opt.size()
	
	for _i in range(op_cnt_i):
		rand_i = randi() % 10000 + 1
		rand_s = String(rand_i)
		while ( rand_s in used_meta_a ):
			rand_i = randi() % 10000 + 1
			rand_s = String(rand_i)
		meta_a.append( rand_s )
		
	
	# assign meta labels to options
	for i in range(s_opt.size()):
		enum_s_opt.append( "[url="+meta_a[x]+"]" + _enum_remove_hidden(s_opt[i])+"[/url]")
		x += 1
	for i in range(d_opt.size()):
		enum_d_opt.append("[url="+meta_a[x]+"]" + _enum_remove_hidden(d_opt[i])+"[/url]")
		x += 1
	
	# send to enum 
	enum_n.set_enum(enum_s_opt, enum_d_opt, d_meta)
	
	# wait for option clicked
	meta_clicked = yield(enum_n, "meta_clicked")
	
	for i in range(meta_a.size()):
		if ( meta_a[i] == meta_clicked ):
			if ( i < s_opt.size()):
				
				response_s = _enum_add_hidden(s_opt[i])
			else :
				dyn_idx    = i - s_opt.size()
				response_s = _enum_add_hidden( d_opt[dyn_idx])
			yield(say_t(cons_o.CHARACTERS.Oedipus,response_s,0.01), "completed")
			return i
	
	print("Clicked recieved on unknow meta !")
	assert(false)
	return -1

# dialoge has been ended, script detatched
func end():
	wait_timer.stop()

func pause():
	wait_timer.stop()
