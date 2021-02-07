class_name Sound
extends Node

var map_key     : int
var traversible : bool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(var key : bool, var trav : bool):
	map_key = key
	traversible = trav

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
