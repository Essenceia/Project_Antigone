extends PopupDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var me_n : PopupDialog
# Called when the node enters the scene tree for the first time.
func _ready():
	me_n = self
	pass # Replace with function body.

func show_hyper( var msg:String):
	var key : Array
	me_n.set_text(msg)
	me_n.visible = true
	pass

func hide_hyper():
	me_n.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

