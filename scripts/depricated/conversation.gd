extends VBoxContainer

const WRITE_TIME = 0.01 # TODO change on realease

var text_n       : RichTextLabel
var conv_n       : VBoxContainer
var title_n      : Label
var cons_o       : Object
var conv_panel_n : PanelContainer

#stauts of player particiaptation, 0 : none. 1 : passive, 2 : active
var focus_i          : int 
var participants_a   : Array
var conv_current_tag : String # current tag the conversation is at
var text_buff        : PoolStringArray
var line_buff        : String
var line_buff_idx    : int
var line_buff_len    : int
var write_timer      : Timer

func _ready():
	var err
	cons_o       = get_node("/root/Common")
	conv_panel_n = get_node("conv_panel")
	text_n       = get_node("conv_panel/conv_margin/dialoge")
	title_n      = get_node("conv_title/hbox/title")
	write_timer  = get_node("timer_write")
	conv_n       = self
	
	# set timer config
	write_timer.autostart = false
	write_timer.one_shot  = true
	
	# set signal connection
	# <source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	err =  text_n.connect("meta_clicked",       conv_n , "hyper_clicked")
	err += text_n.connect("meta_hover_started", text_n , "_on_text_meta_hover_started")
	err += text_n.connect("meta_hover_ended",   text_n , "_on_text_meta_hover_ended")
	err += write_timer.connect("timeout",       conv_n , "_write_text")
	if err != OK :
		print("Error : connection")
		assert(false)
		

func start(var first_tag : String, var participants : Array, var focus : int, var panel_style : String):
	var panel_style_res
	# set parameters
	focus_i        = focus;
	participants_a = participants

	# init state
	update_title()
	clear_text()
	panel_style_res = load("res://style_box_flat/"+panel_style+".tres")
	conv_panel_n.set('custom_styles/panel', panel_style_res)
	
	# get text at dic entry
	text_buff = cons_o.expand_dic_tag(first_tag)
	dialoge_continue()



# parse content of text buff and appand all the lines together into the line_buff
# expand special symbols into bb code : @x
# starts write timer
func dialoge_continue():
	var i           : int
	var last_code   : int
	var char_id     : int
	var line        : String
	var char_id_str : String
	
	i = text_buff.size()
	
	for l in range(text_buff.size()):
		# check if not known lable
		line        = text_buff[l]
		last_code   = 0
		char_id_str = ""
		
		i = line.find("@")
		if (  i != -1 ):
			for x in range(2):
				if ( i+x < line.length() ):
					if ( line[i+x] in ["0","1","2","3","4","5","6","7","8","9"]):
						char_id_str += line[i+x]
						last_code = i+x
			
		if (!char_id_str.empty()):
			char_id = int(char_id_str) # cast to string
			line_buff += cons_o.get_chara_name_bb(char_id) + " : "  + line.right(last_code+1)+ '\n'
		else:
			line_buff += line+ '\n'
	text_buff     = [] 
	line_buff_len = line_buff.length()
	line_buff_idx = 0
	write_timer.start(WRITE_TIME)

func _write_text():
	if (line_buff_idx < line_buff_len):
		var err
		# parse bbcode labels to the end
		if (line_buff[line_buff_idx]=="["):
			var bb_label      : String
			var bb_label_end  : String
			var eq_idx        : int
			var bra_idx       : int
			var label_start_idx : int
			var label_end_idx : int
			eq_idx          = line_buff.findn("=", line_buff_idx+1)
			bra_idx         = line_buff.findn("]", line_buff_idx+1)
			label_start_idx = eq_idx if ( eq_idx != -1 && eq_idx < bra_idx) else bra_idx
			bb_label        = line_buff.right(line_buff_idx+1).left(label_start_idx-line_buff_idx-1)
			# find next label
			bb_label_end  = "[/" + bb_label + "]"
			label_end_idx = line_buff.findn( bb_label_end, label_start_idx)
			if (label_end_idx!= -1):
				label_end_idx += 3 + bb_label.length()
				bb_label       = line_buff.right(line_buff_idx).left(label_end_idx - line_buff_idx)
				err            = text_n.append_bbcode(bb_label)
				line_buff_idx   += label_end_idx - line_buff_idx
			else :
				print("Error, end of bb code label not found for label <"+ bb_label + ">\n in string \n<"+ line_buff +"\n > \n at index "+ String(line_buff_idx))
				assert(false)
		else:
			err = text_n.append_bbcode(line_buff[line_buff_idx])
			if err != OK:
				print("Error in appaned bbcode "+err)
				assert(false)
			line_buff_idx += 1
		write_timer.start(WRITE_TIME)
	else :
		write_timer.stop()
		line_buff     = ""
		line_buff_idx = 0
		line_buff_len = 0
	
func clear_text():
	text_n.clear()

func hyper_clicked(var tag_name : String):
	print("tag clicked")
	# TODO : deactivate the hyperlink
	var hyper_text_str : String
	var next_tag_str   : String
	
	update_participation(2)
	
	print("5")
	hyper_text_str = cons_o.get_dic(tag_name)
	print("6")
	next_tag_str   = cons_o.get_next_dic_tag(hyper_text_str)
	
	cons_o.set_event(tag_name)
	
	print("2")
	text_buff      = cons_o.expand_dic_tag(next_tag_str)
	print("3")
	dialoge_continue()
	print("4")


func update_participation(var player_participation : int ):
	if ( focus_i != player_participation):
		# player status in the converation has changed
		if (focus_i != 0) && (player_participation == 0):
			# player has left the conversation
			leave_conv()
		else :
			join_conv()
	focus_i = player_participation
	update_title()


func update_title():
	var new_title : String = ""
	for i in participants_a.size():
		if ( i != 0):
			new_title += ", "
		new_title += cons_o.get_chara_name(participants_a[i])
	if ( focus_i != 0 ):
		new_title += ", " + cons_o.get_chara_name(cons_o.CHARACTERS.Oedipus)
	title_n.set_text(new_title)
	pass
	
func leave_conv():
	print("Player has left conversation")
	pass
	
func join_conv():
	print("Player has joined conversation")
	pass
