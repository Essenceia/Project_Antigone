extends Node

var out       : Node

func _ready():
	out        = get_node("out")


func link(var enum_link : RichTextLabel,  var title_link : Label, var victime : Object, var id : int):
	out.link(enum_link,title_link,victime,id)
	# clean current status
	victime.clear_text()

func get_id()-> int:
	return out.get_id()

func end():
	out.end()

func pause():
	out.pause()

func start():
	var enum_choice
	# code starts here 
	out.say(1,"Hello")
	enum_choice = out.say_enum(["How are you","Word","Life is a lie"],
				  [" * he said smiling * ", ""," * he said depressingly * "],
				  [],[],[] )
	match enum_choice :
		0:
			out.say(1,"Good and you ?")
		1:
			out.say_t(1,"What ??")
		2:
			out.say(1,"How is it a lie ?")
