extends CharacterBody3D

var player = null

const SPEED = 1.0
const ATTACK_RANGE = 2.5

## Jakiego gracza ma śledzić, do wyboru w inspektorze
@export var player_path : NodePath

@onready var nav_agent = $PathFinding

func _ready() -> void:
	player = get_node(player_path)

func _process(_delta: float) -> void:
	velocity = Vector3.ZERO
	
	# Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x, global_position.y,
					player.global_position.z), Vector3.UP)
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	player._got_hit()
	print("Gracz trafiony")
