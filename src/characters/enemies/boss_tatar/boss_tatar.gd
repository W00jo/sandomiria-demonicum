extends CharacterBody3D
## Szef Tatar - boss z atakiem obszarowym.
##
## Większy, wolniejszy Tatar z mechaniką ground effect jak w MMO.[br]
## Zamiast bezpośredniego ataku, tworzy strefę obrażeń pod sobą.[br]
## [br]
## [b]Fazy ataku:[/b][br]
## 1. [b]Warning (1.5s)[/b] - żółta strefa, pulsuje, brak obrażeń[br]
## 2. [b]Damage (3s)[/b] - czerwona strefa, zadaje obrażenia co 0.5s[br]
## [br]
## Boss zmienia kolor wraz ze strefą (wizualny feedback).[br]
## Gracz powinien uciekać gdy widzi żółtą strefę![br]
## [br]
## Inspirowane mechanikami z [i]FFXIV[/i] i innych MMO.
##
## @experimental

## Referencja do gracza (ustawiana z [member player_path] w [method _ready]).
var player: Node3D = null

## Prędkość poruszania się Szefa (wolniejszy od zwykłego Tatara).
const SPEED: float = 0.8

## Zasięg w którym Szef zaczyna atak obszarowy.
const ATTACK_RANGE: float = 3.0

## Czas między atakami obszarowymi (dłuższy cooldown, mocniejszy atak).
@export var attack_cooldown: float = 4.0

## Obrażenia zadawane co tick gdy gracz stoi w strefie.
@export var damage_per_tick: float = 3.0

## Jak długo trwa faza obrażeń strefy (w sekundach).
@export var charge_duration: float = 3.0

## Promień strefy obrażeń (w jednostkach Godota).
@export var area_radius: float = 5.0

## Maksymalne zdrowie Szefa (znacznie więcej niż zwykły Tatar).
@export var max_health: float = 50.0

## Aktualne zdrowie - resetowane do [member max_health] w [method _ready].
var current_health: float = 50.0

## Ścieżka do node'a gracza (ustawiana w inspektorze).[br]
## [b]Wymagane![/b]
@export var player_path: NodePath

## Agent nawigacji do pathfindingu.
@onready var nav_agent: NavigationAgent3D = $PathFinding

## Wizualna strefa obrażeń (mesh + collider).
@onready var damage_area: Node3D = $DamageArea

## Model 3D Szefa (do zmiany koloru podczas ataku).
@onready var boss_model: MeshInstance3D = $BossTatarModel

## Czy Szef może zaatakować (cooldown).
var can_attack: bool = true

## Czy Szef jest w trakcie ataku obszarowego.
var is_attacking: bool = false

## Lista graczy obecnie w strefie obrażeń.
## Uwaga: Obecnie nieużywane, obrażenia liczone po dystansie.
var players_in_area: Array[Node3D] = []

## Oryginalny materiał Szefa (do resetu po ataku).
var original_material: StandardMaterial3D

func _ready() -> void:
	player = get_node(player_path)
	current_health = max_health
	
	# Kopiujemy materiał żeby móc go modyfikować bez wpływu na oryginał
	original_material = boss_model.material_override.duplicate()
	
	# Sygnały dla śledzenia graczy w strefie
	damage_area.area_entered.connect(_on_area_entered)
	damage_area.area_exited.connect(_on_area_exited)


## Główna pętla AI Szefa Tatara.[br]
## [br]
## Identyczna logika co zwykły Tatar, ale wywołuje [method _perform_area_attack].
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


## Wykonuje atak obszarowy w stylu MMO ground effect.[br]
## [br]
## [b]Sekwencja:[/b][br]
## 1. Pokaż strefę (żółta, pulsująca) - 1.5s warning[br]
## 2. Zmień na czerwoną - faza obrażeń[br]
## 3. Zadawaj obrażenia co 0.5s przez [member charge_duration][br]
## 4. Schowaj strefę, zresetuj kolory[br]
## 5. Cooldown [member attack_cooldown][br]
## [br]
## Boss i strefa zmieniają kolor synchronicznie dla lepszego feedbacku.
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
		# Red danger color for boss
		boss_material.albedo_color = Color(1.0, 0.9, 0.0, 1)
		
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
