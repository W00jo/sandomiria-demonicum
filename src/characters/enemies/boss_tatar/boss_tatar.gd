extends CharacterBody3D

## Boss Tatar with area damage attack
var player = null
const SPEED = 0.8
const ATTACK_RANGE = 3.0
## Cooldown between area attacks
@export var attack_cooldown = 4.0
## Damage dealt per tick in area
@export var damage_per_tick: float = 3.0
## Total duration of the charged area
@export var charge_duration: float = 3.0
## Radius of the damage area
@export var area_radius: float = 5.0
## Boss health
@export var max_health: float = 50.0
var current_health: float = 50.0

## Player to track
@export var player_path : NodePath

@onready var nav_agent = $PathFinding
@onready var damage_area = $DamageArea
@onready var boss_model = $BossTatarModel

# Attack state variables
var can_attack: bool = true
var is_attacking: bool = false
var players_in_area: Array[Node3D] = []
var original_material: StandardMaterial3D

func _ready() -> void:
	player = get_node(player_path)
	current_health = max_health
	
	# Store original material
	original_material = boss_model.material_override.duplicate()
	
	# Connect area signals
	damage_area.area_entered.connect(_on_area_entered)
	damage_area.area_exited.connect(_on_area_exited)

func _process(_delta: float) -> void:
	# Stop moving during attack
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

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

## Area damage attack - similar to MMO ground effects
func _perform_area_attack() -> void:
	is_attacking = true
	can_attack = false
	
	# Show the area indicator (visual effect showing where damage will happen)
	damage_area.show()
	var area_mesh = damage_area.get_node("DamageAreaMesh")
	var area_material = area_mesh.material_override.duplicate()
	area_mesh.material_override = area_material
	
	# Create boss material for color changes
	var boss_material = boss_model.material_override.duplicate()
	boss_model.material_override = boss_material
	
	# Warning phase - area appears with yellow/orange color but no damage yet
	var warning_duration = 1.5
	var warning_timer = 0.0
	while warning_duration > 0.0:
		warning_duration -= get_physics_process_delta_time()
		# Pulsing effect during warning phase
		var pulse = sin(warning_timer * 4.0) * 0.4 + 0.6
		damage_area.scale = Vector3(pulse, 1.0, pulse)
		# Yellow warning color for area
		area_material.albedo_color = Color(1.0, 1.0, 0.0, 0.7)
		area_material.emission = Color(1.0, 0.8, 0.0, 1)
		# Yellow warning color for boss
		boss_material.albedo_color = Color(1.0, 0.9, 0.0, 1)
		warning_timer += get_physics_process_delta_time()
		await get_tree().process_frame
	
	# Charge phase - area changes to red and damage builds up
	var charge_timer = 0.0
	var damage_tick_interval = 0.5
	var last_damage_time = 0.0
	damage_area.scale = Vector3(1.0, 1.0, 1.0)  # Reset scale
	
	while charge_timer < charge_duration:
		charge_timer += get_physics_process_delta_time()
		last_damage_time += get_physics_process_delta_time()
		
		# Faster pulsing during damage phase
		var damage_pulse = sin(charge_timer * 6.0) * 0.3 + 0.7
		damage_area.scale = Vector3(damage_pulse, 1.0, damage_pulse)
		# Red danger color for area
		area_material.albedo_color = Color(1.0, 0.1, 0.1, 0.8)
		area_material.emission = Color(1.0, 0.0, 0.0, 1)
		# Red danger color for boss
		boss_material.albedo_color = Color(1.0, 0.0, 0.0, 1)
		
		# Deal damage to players in area periodically
		if last_damage_time >= damage_tick_interval:
			_damage_players_in_area()
			last_damage_time = 0.0
		
		await get_tree().process_frame
	
	# Hide area and reset boss color
	damage_area.hide()
	damage_area.scale = Vector3(1.0, 1.0, 1.0)  # Reset scale
	boss_material.albedo_color = original_material.albedo_color  # Reset boss color
	
	is_attacking = false
	
	# Cooldown before next attack
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _damage_players_in_area() -> void:
	# Check if player is within the damage area radius
	if player and global_position.distance_to(player.global_position) <= area_radius:
		if player.has_method("take_damage"):
			player.take_damage(damage_per_tick)
			print("Gracz w obszarze Szefa za ", damage_per_tick, " dmg")

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		if area not in players_in_area:
			players_in_area.append(area)

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		if area in players_in_area:
			players_in_area.erase(area)

func take_damage(amount: float):
	current_health -= amount
	print("Szef Tatar otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()

func _die():
	print("Szef Tatar =/= żywy")
	queue_free()
