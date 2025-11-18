extends Node

@onready var hud_container = $HUDLayer

func spawn_player(character_type: String):
	var player = load("res://characters/" + character_type + ".tscn").instantiate()
	var hud = load("res://hud/" + character_type + "_hud.tscn").instantiate()
	
	add_child(player)
	hud_container.add_child(hud)
	
	# Connect signals
	hud.set_player(player)
