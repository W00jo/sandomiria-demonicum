extends CharacterBody3D

## 
var player = null
const SPEED = 1.0
const ATTACK_RANGE = 2.5 
## Cooldown ataku Tatara (nie tego do jedzenia)
@export var attack_cooldown = 2.0
## Obrażenia zadawane graczowi
@export var damage: float = 10.0
## Zdrowie Tatara
@export var max_health: float = 2.0
var current_health: float = 2.0

## Jakiego gracza ma śledzić, do wyboru w inspektorze
@export var player_path : NodePath

@onready var nav_agent = $PathFinding

# Zmienne attack state
var can_attack: bool = true
var is_attacking: bool = false

func _ready() -> void:
	player = get_node(player_path)
	current_health = max_health

func _process(_delta: float) -> void:
	# Dla balansu zatrzymuje się podczas "animacji" ataku
	if is_attacking:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	# Sprawdza czy gracz jest w zasięgu ataku
	if _target_in_range():
		velocity = Vector3.ZERO
		look_at(Vector3(player.global_position.x, global_position.y,
						player.global_position.z), Vector3.UP)
		if can_attack:
			_perform_attack()
	
	# Nawigacja gracza
	else:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
		look_at(Vector3(player.global_position.x, global_position.y,
						player.global_position.z), Vector3.UP)
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

## System ataku Tatara
func _perform_attack() -> void:
	is_attacking = true
	can_attack = false
	
	# Jak już dodamy animacji trzeba to podmienić!!
	await get_tree().create_timer(0.5).timeout
	
	# Sprawdza czy gracz jest po zakończeniu animacji w zasięgu, jeśli tak to go uderzy
	if _target_in_range():
		_hit_finished()
	
	is_attacking = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _hit_finished():
	if player and player.has_method("take_damage"):
		player.take_damage(damage)
		print("Gracz trafiony przez Tatara za ", damage, " dmg")

func take_damage(amount: float):
	current_health -= amount
	print("Tatar otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()

func _die():
	print("Tatar =/= żywy")
	queue_free()  # Usuń wroga ze sceny
