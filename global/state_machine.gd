class_name StateMachine
extends Node

@export var CURRENT_STATE : State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("Maszyna stanów zawiera niekompatybilny child node")
	CURRENT_STATE._enter()

func _process(delta):
	CURRENT_STATE._update(delta)

func _physics_process(delta):
	CURRENT_STATE._physics_update(delta)

func on_child_transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE._exit()
			new_state._enter()
			CURRENT_STATE = new_state
	else:
		push_warning("Stan nie istnieje ciulu!!!!!") 
