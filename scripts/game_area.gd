extends PanelContainer

const MAX_DIALOGUE_NUM : int = 2
# In charge of spawning new conv's
# Moving the focus between conv's
# Managing location of characters withing conv's
# Pausing override
var me_n          : PanelContainer
var hsplit_n      : HSplitContainer
var conv_resource = preload("res://scenes/conv.tscn")

var conv_n  : Dictionary        # array of conversations


# Called when the node enters the scene tree for the first time.
func _ready():
	me_n          = self
	hsplit_n      = get_node("hsplit")

func end_all_dialogues():
	var sucess : bool
	var keys : Array
	for k in keys:
		sucess = conv_n.erase(k)
		if (!sucess):
			assert(false)

func start_new_dialogue(var conversation_id : int, var focus : int, var color : String):
	conv_n[conversation_id] = conv_resource.instance()
	hsplit_n.add_child(conv_n[conversation_id])
	# set start
	conv_n[conversation_id].start(focus,color)
	# set dialogue
	conv_n[conversation_id].attach_new_dialogue_script(conversation_id)
	# start dialogue
	conv_n[conversation_id].dialogue_start()

func has_max_dialogue()-> bool:
	return ( MAX_DIALOGUE_NUM + 1 < conv_n.size() )

func get_current_dialogue_id()-> Array :
	return conv_n.keys()
