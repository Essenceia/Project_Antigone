extends Node


var text_n         : RichTextLabel
var enum_n         : RichTextLabel
var title_n        : Label
var conv_panel_n   : PanelContainer
var enum_panel_n   : PanelContainer
var dialogue_n     : Node
var dialogue_DB_o  : Node
var vbox_n         : VBoxContainer
#stauts of player particiaptation, 0 : none. 1 : passive, 2 : active
var focus_i          : int 

func _ready():
	
	conv_panel_n   = get_node("vbox/conv_panel")
	dialogue_DB_o  = get_node("/root/DialogueDb")
	title_n        = get_node("vbox/conv_title/hbox/title")
	text_n         = get_node("vbox/conv_panel/conv_margin/conv_text")
	enum_n         = get_node("vbox/enum/enum_margin/enum_text")
	enum_panel_n   = get_node("vbox/enum")
	vbox_n         = get_node("vbox")
	
	focus_i       = 0
	
	vbox_n.visible = false

func start(var focus : int, var panel_style : String):
	var panel_style_res
	var err 
	
	focus_i = focus
	# set parameters
	panel_style_res = load("res://style_box_flat/"+panel_style+".tres")
	conv_panel_n.set('custom_styles/panel', panel_style_res)
	
	enum_n.link(enum_panel_n)
	err = text_n.connect("meta_clicked", enum_n, "text_meta_clicked")
	assert(err == OK)
	
	randomize()

func dialogue_start():
	vbox_n.visible = true
	dialogue_n.start()

func attach_new_dialogue_script(var dialogue_id : int):
	var new_script
	var dialogue_name : String
	
	dialogue_name = dialogue_DB_o.get_dialogue_name(dialogue_id)
	
	if (dialogue_n != null):
		# detatch script
		dialogue_n.end()
		dialogue_n.free()
	
	new_script            = load("res://scripts/text_systems/story_conversations/"+dialogue_name+".gd")
	var dialogue_resource = load("res://scenes/dialogue.tscn")
	if ( new_script == null || dialogue_resource == null ):
		print("Error loading script "+dialogue_name)
		assert(false)
	
	dialogue_n = dialogue_resource.instance()
	dialogue_n.set_script(new_script)
	self.add_child(dialogue_n)
	
	if (dialogue_n == null):
		print("Error scipt assignement failed "+dialogue_name)
		assert(false)
	
	dialogue_n.link(enum_n, title_n , text_n,  dialogue_id)
	dialogue_DB_o.set_triggered(dialogue_n.get_id())
	
func update_title(var new_title : String):
	title_n.set_text(new_title)
	
