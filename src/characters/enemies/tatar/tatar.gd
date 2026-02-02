extends CharacterBody3D
## Podstawowy wróg = Tatar (nie ten do jedzenia).
##
## Podąża za graczem używając [NavigationAgent3D] i atakuje gdy jest w zasięgu.
## Taki standardowy mob do mięsa armatniego.
##
## @experimental

var player: Node3D = null

const SPEED: float = 1.0
const ATTACK_RANGE: float = 2.5

@export var attack_cooldown: float = 2.0
@export var damage: float = 10.0
@export var max_health: float = 2.0

var current_health: float = 2.0

## Ścieżka do node'a gracza (ustawiana w inspektorze).
@export var player_path: NodePath

## Agent nawigacji do pathfindingu.
@onready var nav_agent: NavigationAgent3D = $PathFinding

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
	
	# Nawigacja do gracza
	else:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
		look_at(Vector3(player.global_position.x, global_position.y,
						player.global_position.z), Vector3.UP)
	
	move_and_slide()

func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
## TODO: Dodać prawdziwą animację ataku.
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


## Zadaje obrażenia graczowi po zakończeniu animacji ataku.[br]
## Wywoływane tylko jeśli gracz nadal jest w [constant ATTACK_RANGE].
func _hit_finished() -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(damage)
		print("Gracz trafiony przez Tatara za ", damage, " dmg")


## Zadaje obrażenia Tatarowi.[br]
## [br]
## Wywoływane przez system walki gracza.[br]
## Gdy HP spadnie do 0, wywołuje [method _die].[br]
## [br]
## @param amount Ilość obrażeń do zadania.
func take_damage(amount: float) -> void:
	current_health -= amount
	print("Tatar otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()


## Usuwa Tatara ze sceny i kończy jego żywot.[br]
## Wywoływane gdy [member current_health] <= 0.
func _die() -> void:
	print("Tatar =/= żywy")
	queue_free()
