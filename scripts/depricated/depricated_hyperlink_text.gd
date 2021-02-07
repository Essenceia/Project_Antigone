extends RichTextLabel

# timer used to not update the hyper_text within a certain time, presents it's flickering
const default_pos_timeout : float = 2.0
const default_vis_timeout : float = 0.005
var   update_pos_timer    : Timer
var   update_vis_timer    : Timer
var   vis                 : bool
var   current_tag         : String

var text_n       : RichTextLabel
var hyper_n      : PopupDialog
var hyper_text_n : Label
var cons_o       : Node
var text_font    : Font

func _ready():
	hyper_n          = get_node("hyper")
	cons_o           = get_node("/root/Common")
	hyper_text_n     = get_node("hyper/hyper_text")
	update_pos_timer = get_node("hyper/hyper_text/timer_pos")
	update_vis_timer = get_node("hyper/hyper_text/timer_vis")
	text_n           = self
	
	# timer configuration
	update_pos_timer.autostart = false
	update_pos_timer.one_shot  = true
	update_vis_timer.autostart = false
	update_vis_timer.one_shot  = true
	current_tag                = ""
	
	# set signal connection
	# <source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	var err = update_vis_timer.connect("timeout", text_n, "hide_hyper")
	if err != OK:
		print("Error, connection error ")
		assert(false)
	
	text_font = hyper_text_n.get_font("Modeseven_theme","Label")

# Hyper management 
func _on_text_meta_hover_ended(_meta):
	print("Hover of hypertext ended")
	update_vis_timer.start(default_vis_timeout)

func hide_hyper():
	hyper_n.visible = false

func _on_text_meta_hover_started(meta):
	# move position of the hyper box to above the selected text
	var mouse_pos       : Vector2
	var t_s             : float
	var new_text        : String
	var new_text_size   : Vector2
	var new_text_pos    : Vector2
	var window_size     : Vector2
	
	print("On hover start")
	t_s      = update_pos_timer.get_time_left()
	
	if ( (t_s == 0.0) || (meta != current_tag)):
		print("New tag found "+meta)
		
		mouse_pos   = get_viewport().get_mouse_position()
		window_size = get_viewport().get_size()
		
		new_text          = cons_o.get_dic_hyper_text(meta)
		hyper_text_n.text = new_text 
		current_tag       = meta
		
		#update hyper size and postion
		new_text_size = text_font.get_string_size(new_text)
		print("New box size should be : ", new_text_size.x , ", y : ", new_text_size.y)

		if (new_text_size.x + mouse_pos.x > window_size.x ):
			new_text_pos.x  = window_size.x - new_text_size.x
		else:
			new_text_pos.x  = mouse_pos.x
		if (new_text_size.y + mouse_pos.y > window_size.y ):
			new_text_pos.y  = window_size.y - new_text_size.y
		else:
			new_text_pos.y  = mouse_pos.y

		# position text
		hyper_n.set_position(new_text_pos)

		# set up window size
		hyper_n.margin_right  = hyper_n.margin_left + new_text_size.x + 20
		hyper_n.margin_bottom = hyper_n.margin_top  + new_text_size.y + 20

	else : 
		print("Can't move hyperlink, timer : ", t_s , " s")
	
	print("hypertext box shown with content "+hyper_text_n.text)
	update_pos_timer.start(default_pos_timeout)
	update_vis_timer.stop()
	hyper_n.visible = true
	

