extends RichTextLabel

var char_time_s = 0.01 # TODO change on realease

var line_buff        : String
var line_buff_idx    : int
var line_buff_len    : int
var write_timer      : Timer
var text_n           : RichTextLabel

func _ready():
	write_timer  = get_node("timer_write")
	text_n       = self
	
	# set timer config
	write_timer.autostart = false
	write_timer.one_shot  = true

# fill write buffer and starts write timer, will return once the text print has finished
func dialoge(var line : String, var char_time : float):
	line_buff     = line
	line_buff_len = line_buff.length()
	line_buff_idx = 0
	char_time_s = char_time
	yield( _write_text() , "completed")

func _write_text():
	var _err
	
	write_timer.start(char_time_s)
	write_timer.set_one_shot(false)
	print("write text "+line_buff+ "\n len : ", line_buff.length())
	print("line_buff_idx ", line_buff_idx)
	print("line_buff_len ", line_buff_len)
	while (line_buff_idx < line_buff_len):
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
				_err            = text_n.append_bbcode(bb_label)
				print("bb label" +bb_label)
				line_buff_idx += bb_label.length()
			else :
				print("Error, end of bb code label not found for label <"+ bb_label + ">\n in string \n<"+ line_buff +"\n > \n at index "+ String(line_buff_idx))
				assert(false)
		else:
			# not currently in a bbcode label
			_err = text_n.append_bbcode(line_buff[line_buff_idx])
			print(line_buff[line_buff_idx])
			if _err != OK:
				print("Error in appaned bbcode "+_err)
				assert(false)
			line_buff_idx += 1
	
		# wait until timer runs out before posting next char
		yield(write_timer, "timeout")

	# clean up before exit
	_err = text_n.append_bbcode("\n")
	if _err != OK:
		print("Error in appaned bbcode "+_err)
		assert(false)
	write_timer.stop()
	line_buff     = ""
	line_buff_idx = 0
	line_buff_len = 0
	
func clear_text():
	print("Clear text called")
	line_buff = ""
	text_n.set_text("") #clear text
	write_timer.stop()

