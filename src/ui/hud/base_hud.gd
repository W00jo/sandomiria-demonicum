extends Node

@onready var got_hit: ColorRect = $GotHit
@onready var crosshair: TextureRect = $Crosshair
@onready var direction_indicator: TextureRect = $DirectionIndicator
@onready var hitmarker: TextureRect = $Hitmarker

## Referencja do broni gracza
var weapon: Node3D

func _ready():
	var screen_size = get_viewport().size
	# Wyśrodkuj crosshair, hitmarker i direction_indicator
	crosshair.position = Vector2(screen_size.x / 2 - 32, screen_size.y / 2 - 32)
	hitmarker.position = Vector2(screen_size.x / 2 - 32, screen_size.y / 2 - 32)
	direction_indicator.position = Vector2(screen_size.x / 2 - 32, screen_size.y / 2 - 32)
	
	# Znajdź broń gracza
	await get_tree().process_frame
	var player = get_parent()
	if player:
		weapon = player.get_node_or_null("Head/Camera3D/Dagger")

func _process(_delta: float) -> void:
	if not weapon:
		return
	
	# Obrót indykatora w zależności od kierunku ruchu myszki
	match weapon.current_direction:
		1:  # LEFT
			direction_indicator.rotation_degrees = -90
		2:  # RIGHT
			direction_indicator.rotation_degrees = 90
		3:  # UP
			direction_indicator.rotation_degrees = 0
		4:  # DOWN
			direction_indicator.rotation_degrees = 180
	
	# Zmienia kolor, przy zablokowaniu
	if weapon.direction_locked:
		direction_indicator.modulate = Color(0.932, 0.602, 0.0, 1.0)
	else:
		direction_indicator.modulate = Color(1, 1, 1, 1)

func _on_dagger_enemy_hit() -> void:
	hitmarker.visible = true
	await get_tree().create_timer(0.1).timeout
	hitmarker.visible = false

func _on_player_player_hit() -> void:
	got_hit.visible = true
	await get_tree().create_timer(0.2).timeout
	got_hit.visible = false
