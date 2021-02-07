class_name Character
extends Node

enum GRADE {A = 0, B = 1, C = 2, D = 3}

var id  : int 
var name_used : String

var standing : Vector2 # ( friendly, trust )

var active : bool

var cons_o     : Node
var name_color : String

func _init(var char_id: int, var alive : bool):
	id         = char_id
	active     = alive
	standing.x = 0.0
	standing.y = 0.0

# has to be called after init_ as links get construncted in between the call to init and ready
func start():
	cons_o     = self.get_parent()
	if cons_o == null:
		print("Error in getting parent is null")
		assert(false)
	update_name()
	
func update_name():
	name_used  = cons_o.CHARACTERS_STR[get_standing_grade()][id]
	name_color = cons_o.CHARACTERS_COLOR[get_standing_grade()][id]

func get_name_bb():
	return "[color="+name_color+"]{"+name_used+"}[/color]"

func get_name():
	return name_used

func get_standing_grade():
	var grade : int
	# set a default value
	grade = GRADE.A
	return grade

func update_standing(var x:float, var y:float):
	standing.x += x
	standing.y += y
	update_name()
	
