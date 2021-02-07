extends VBoxContainer

const DIALOGUE_EVAL_TIME : float = 2.0
var spacial             : Node2D
var game_area           : PanelContainer
var gloabal_ressources  : Node
var dialogue_db         : Node
# used to call the dialogue trigger 
var dialogue_timer  : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	var err
	spacial            = get_node("spatial")
	game_area          = get_node("screen/game_area")
	gloabal_ressources = get_node("global_ressources")
	dialogue_timer     = get_node("dialogue_trigger_timer")
	dialogue_db        = get_node("dialogue")
	
	dialogue_timer.autostart = false
	dialogue_timer.one_shot  = true
	dialogue_timer.start(1)
	err = dialogue_timer.connect("timeout",self,"start")
	if err != OK:
		assert(false)

func start():
	var err
	# init navigation
	spacial.start()
	spacial.init_chara_pos()
	# init dialgue
	err = dialogue_timer.connect("timeout",self,"get_dialogue_for_area")
	if err != OK:
		assert(false)
	dialogue_timer.start(DIALOGUE_EVAL_TIME)

func get_dialogue_for_area():
	var dialogues             : PoolIntArray 
	var main_chara_pos        : String
	var charas_at_pos         : PoolIntArray
	var current_events        : PoolStringArray
	var potencial_dialogue_id : Array
	var current_dialogue_id   : Array
	var dialogue_id           : int
	var proba_f               : float
	var rand_f                : float
	var more_space            : bool
	
	if !game_area.has_max_dialogue():
		# we can still fit at least one more dialogue
		dialogue_id    = -1
		more_space     = true
		main_chara_pos = spacial.get_current_position(0)
		charas_at_pos  = spacial.get_characters_in_postion(main_chara_pos)
		current_events = gloabal_ressources.get_event_pool_str()
		
		while((dialogue_id != -2) || (dialogue.size())):
			dialogue_id = dialogue_db.get_next_dialogue_id(dialogue_id, main_chara_pos, charas_at_pos, current_events)
			if ( dialogue_id > -1):
				potencial_dialogue_id.append(dialogue_id)
		
		# end of while, remove all dialogue id's that match currently running conversations
		current_dialogue_id = game_area.get_current_dialogue_id()
		for k in current_dialogue_id:
			if potencial_dialogue_id.has(k):
				potencial_dialogue_id.erase(k)
		
		# go throught the remaining dialogue candidates and pool based on probability
		for d in potencial_dialogue_id:
			proba_f = dialogue_db.get_dialogue_proba(d)
			rand_f  = rand_range(0.0, 1.0)
		
			if proba_f >= rand_f :
				game_area.start_new_dialogue(d, dialogue_db.get_dialogue_is_passive(d), "dark_cyan") # TODO, variable color, hard coded here
				if game_area.has_max_dialogue():
					more_space = false
					break # leave iteration loop
		
		if more_space:
			dialogue_timer.start(DIALOGUE_EVAL_TIME)
		else:
			dialogue_timer.stop()
