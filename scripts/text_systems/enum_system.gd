extends RichTextLabel


var d_meta_seen_a  : Array
var text_s         : String
var active         : bool
var current_d_meta : PoolStringArray
var current_s_opt  : PoolStringArray
var current_d_opt  : PoolStringArray
var enum_contrainer : PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	var err 
	err = self.connect("meta_clicked", self, "fun_meta_clicked")
	if err != OK:
		assert(false)

func link(var parent_container : PanelContainer):
	assert(parent_container!=null)
	enum_contrainer = parent_container
	update_visibility()
func reset():
	d_meta_seen_a.clear()
	active = false
	text_s = ""
	current_d_opt  = []
	current_d_meta = []
	current_s_opt  = []
	self.text = ""
	if ( enum_contrainer != null ):
		update_visibility()

func update_visibility():
	enum_contrainer.visible = active
	
# A meta was clicked on in the text
func text_meta_clicked(var meta : String):
	if !(meta in d_meta_seen_a):
		d_meta_seen_a.append(meta)
		if (active == true) :
			update_enum()

func update_enum():
	var tmp_s : String
	var _err 
	# clear text
	self.text = ""
	# print static options
	tmp_s = ""
	for i in range(current_s_opt.size()):
		if i != 0:
			tmp_s += "\n"
		tmp_s += current_s_opt[i]
	for i in range(current_d_opt.size()):
		if current_d_meta[i] in d_meta_seen_a:
			tmp_s += "\n"+current_d_opt[i]
	_err = append_bbcode(tmp_s)
	print("Enum append bb code :\n"+tmp_s)
	#assert(err != 0)
	
func set_enum(var s_opt : PoolStringArray, var d_opt : PoolStringArray, var d_meta : PoolStringArray):
	active = true
	
	current_s_opt  = s_opt
	current_d_opt  = d_opt
	current_d_meta = d_meta
	self.text = ""
	print("Set to enum called")
	update_enum()
	update_visibility()

func fun_meta_clicked(var meta : String) -> String:
	active = false
	update_visibility()
	return meta

