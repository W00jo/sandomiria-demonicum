extends Node

@onready var got_hit: ColorRect = $GotHit
@onready var crosshair: TextureRect = $Crosshair
@onready var direction_indicator: TextureRect = $DirectionIndicator
@onready var hitmarker: TextureRect = $Hitmarker

func _ready():
	crosshair.position.x = get_viewport().size.x / 2 - 32
	crosshair.position.y = get_viewport().size.y / 2 - 32
	hitmarker.position.x = get_viewport().size.x / 2 - 32
	hitmarker.position.y = get_viewport().size.y / 2 - 32

## Mysle nad czyms takim, aby podstawowy HUD byl dla kazdego
#func spawn_player(character_type: String):
	#var player = load("res://characters/" + character_type + ".tscn").instantiate()
	#var hud = load("res://hud/" + character_type + "_hud.tscn").instantiate()
	#
	#add_child(player)
	#hud_container.add_child(hud)
	#
	## Connect signals
	#hud.set_player(player)

func _on_player_player_hit() -> void:
	got_hit.visible = true
	await get_tree().create_timer(0.2).timeout
	got_hit.visible = false
