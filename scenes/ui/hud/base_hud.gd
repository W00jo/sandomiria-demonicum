extends Node

@onready var hud_container = $HUDLayer
@onready var crosshair = $HUDlayer/Crosshair

func _ready() -> void:
	crosshair.position.x = hud_container.x / 2 - crosshair.size.x / 2
	crosshair.position.y = hud_container.y / 2 - crosshair.size.y / 2

#func spawn_player(character_type: String):
	#var player = load("res://characters/" + character_type + ".tscn").instantiate()
	#var hud = load("res://hud/" + character_type + "_hud.tscn").instantiate()
	#
	#add_child(player)
	#hud_container.add_child(hud)
	#
	## Connect signals
	#hud.set_player(player)
