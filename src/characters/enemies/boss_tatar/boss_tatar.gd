extends CharacterBody3D
## Wódz tatarów
##
## Większy, wolniejszy Tatar z mechaniką AoE jak boss w MMO.
##
## @experimental

var player: Node3D = null

const SPEED: float = 0.8
const ATTACK_RANGE: float = 3.0

@export var attack_cooldown: float = 4.0
@export var damage_per_tick: float = 3.0
@export var charge_duration: float = 3.0
@export var area_radius: float = 5.0
@export var max_health: float = 50.0

var current_health: float = 50.0

@export var player_path: NodePath
@onready var nav_agent: NavigationAgent3D = $PathFinding
@onready var damage_area: Node3D = $DamageArea
@onready var boss_model: MeshInstance3D = $BossTatarModel

var can_attack: bool = true
var is_attacking: bool = false

var players_in_area: Array[Node3D] = []

var original_material: StandardMaterial3D

func _ready() -> void:
	player = get_node(player_path)
	current_health = max_health
	
	# Kopiujemy materiał żeby móc go modyfikować bez wpływu na oryginał
	original_material = boss_model.material_override.duplicate()
	
	# Sygnały dla śledzenia graczy w strefie
	damage_area.area_entered.connect(_on_area_entered)
	damage_area.area_exited.connect(_on_area_exited)

func _process(_delta: float) -> void:
	# Stoi w miejscu podczas ataku obszarowego
	if is_attacking:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	# Check if player is in attack range
	if _target_in_range():
		velocity = Vector3.ZERO
		look_at(Vector3(player.global_position.x, global_position.y,
						player.global_position.z), Vector3.UP)
		if can_attack:
			_perform_area_attack()
	
	# Navigate towards player
	else:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
		look_at(Vector3(player.global_position.x, global_position.y,
						player.global_position.z), Vector3.UP)
	
	move_and_slide()


## Sprawdza czy gracz jest w zasięgu do rozpoczęcia ataku.
func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _perform_area_attack() -> void:
	is_attacking = true
	can_attack = false
	
	# Create boss material for color changes
	var boss_material = boss_model.material_override.duplicate()
	boss_model.material_override = boss_material
	
	# Warning phase - boss turns yellow but no damage yet
	var warning_duration = 1.5
	var warning_timer = 0.0
	while warning_duration > 0.0:
		warning_duration -= get_physics_process_delta_time()
		# Yellow warning color for boss
		boss_material.albedo_color = Color(1.0, 0.9, 0.0, 1)
		warning_timer += get_physics_process_delta_time()
		await get_tree().process_frame
	
	# Charge phase - boss turns red and damage builds up
	var charge_timer = 0.0
	var damage_tick_interval = 0.5
	var last_damage_time = 0.0
	
	while charge_timer < charge_duration:
		charge_timer += get_physics_process_delta_time()
		last_damage_time += get_physics_process_delta_time()
		
		# Red danger color for boss
		boss_material.albedo_color = Color(1.0, 0.0, 0.0, 1)
		
		# Deal damage to players in area periodically
		if last_damage_time >= damage_tick_interval:
			_damage_players_in_area()
			last_damage_time = 0.0
		
		await get_tree().process_frame
	
	# Reset boss color
	boss_material.albedo_color = original_material.albedo_color
	
	is_attacking = false
	
	# Cooldown before next attack
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true


## Zadaje obrażenia graczom w strefie.[br]
## [br]
## Sprawdza dystans do gracza vs [member area_radius].[br]
## Wywoływane co 0.5s podczas fazy damage.
func _damage_players_in_area() -> void:
	if player and global_position.distance_to(player.global_position) <= area_radius:
		if player.has_method("take_damage"):
			player.take_damage(damage_per_tick)
			print("Gracz w obszarze Szefa za ", damage_per_tick, " dmg")


## Callback gdy Area3D wejdzie w strefę obrażeń.[br]
## Dodaje gracza do [member players_in_area] jeśli jest w grupie "player".
func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		if area not in players_in_area:
			players_in_area.append(area)


## Callback gdy Area3D opuści strefę obrażeń.[br]
## Usuwa gracza z [member players_in_area].
func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		if area in players_in_area:
			players_in_area.erase(area)


## Zadaje obrażenia Szefowi Tatarowi.[br]
## [br]
## @param amount Ilość obrażeń do zadania.
func take_damage(amount: float) -> void:
	current_health -= amount
	print("Szef Tatar otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()


## Kończy żywot Szefa Tatara.[br]
## Wywoływane gdy [member current_health] <= 0.
func _die() -> void:
	print("Szef Tatar =/= żywy")
	queue_free()
