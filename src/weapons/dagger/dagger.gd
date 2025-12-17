extends Node3D
## System ataku kierunkowego dla sztyletu.
##
## Gracz wybiera kierunek ruchem myszy, blokuje go prawym przyciskiem,
## a następnie atakuje lewym przyciskiem.

signal enemy_hit

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Typy kierunków ataku
enum AttackDirection {
	LEFT = 1,
	RIGHT = 2,
	UP = 3,
	DOWN = 4
}

## Aktualnie wybrany kierunek ataku (domyślnie pchnięcie)
var current_direction: AttackDirection = AttackDirection.DOWN
## Czy kierunek jest zablokowany prawym przyciskiem myszy
var direction_locked: bool = false
## Czy obecnie trwa animacja ataku
var is_attacking: bool = false

## Strefa "martwa" dla myszy (aby uniknąć przypadkowych zmian kierunku)
@export var dead_zone: float = 50.0

@export_group("Damage stats") # Statystyki obrażeń ataków
@export var base_damage: float = 1
@export var overhead_damage_multiplier: float = 1.5
@export var stab_damage: float = 0.75

@export_group("Attack ranges") # Statystyki szerokości ataków
@export var side_attack_range: float = 1
@export var overhead_attack_range: float = 1
@export var stab_attack_range: float = 1.2

@export_group("Attack areas") # Statystyki zasięgu ataków
@export var side_attack_angle: float = 90.0
@export var overhead_attack_angle: float = 45.0

## Pozycja myszy na środku ekranu
var screen_center: Vector2
## Kiedy kierunek się zmieni (jak bardzo kamerą trzeba majtać)
var accumulated_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2.0

## Lewy przycisk myszy = atak; Prawy przycisk myszy = toggle blokowania/odblokowania kierunku. Sterowanie można modyfikować w `Project > Project Settings` jak coś.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		direction_locked = not direction_locked
		if direction_locked:
			print("Kierunek zablokowany: ", AttackDirection.keys()[current_direction - 1])
		else:
			print("Kierunek odblokowany")
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_attacking:
			perform_attack()
	
	# Aktualizacja kierunku na podstawie pozycji myszy
	if event is InputEventMouseMotion and not direction_locked:
		accumulated_mouse_pos += event.relative
		accumulated_mouse_pos = accumulated_mouse_pos.limit_length(200.0)
		update_attack_direction(accumulated_mouse_pos)

## Określa kierunek ataku na podstawie pozycji myszy (lub względnego ruchu)
func update_attack_direction(mouse_pos: Vector2) -> void:
	var relative_pos: Vector2 = mouse_pos
	
	if relative_pos.length() < dead_zone:
		return
	
	var angle: float = rad_to_deg(relative_pos.angle())
	
	if angle < 0:
		angle += 360
	
	# Określa kierunek na podstawie kąta
	if angle >= 315 or angle < 45:  # Prawo
		current_direction = AttackDirection.RIGHT
	elif angle >= 45 and angle < 135:  # Dół
		current_direction = AttackDirection.DOWN
	elif angle >= 135 and angle < 225:  # Lewo
		current_direction = AttackDirection.LEFT
	else:  # Góra
		current_direction = AttackDirection.UP

## Wykonuje atak w wybranym kierunku
func perform_attack() -> void:
	is_attacking = true
	$DaggerAttackSound.play()
	
	print("Atak w kierunku: ", AttackDirection.keys()[current_direction - 1])
	
	match current_direction:
		AttackDirection.LEFT:
			# TODO: Dodać animację slash_Left
			await get_tree().create_timer(0.5).timeout
			deal_damage_in_area(side_attack_range, side_attack_angle, base_damage)
		AttackDirection.RIGHT:
			# TODO: Dodać animację slash_Right
			await get_tree().create_timer(0.5).timeout
			deal_damage_in_area(side_attack_range, side_attack_angle, base_damage)
		AttackDirection.UP:
			# TODO: Dodać animację overhead
			await get_tree().create_timer(0.5).timeout
			deal_damage_in_area(overhead_attack_range, overhead_attack_angle, base_damage * overhead_damage_multiplier)
		AttackDirection.DOWN:
			# TODO: Dodać animację stab
			await get_tree().create_timer(0.5).timeout
			deal_damage_in_area(stab_attack_range, 30.0, stab_damage)
	
	is_attacking = false

## Zadaje obrażenia wrogom w obszarze ataku
func deal_damage_in_area(range: float, angle_degrees: float, damage: float) -> void:
	var player = get_parent().get_parent()  # TODO: SPRAWDZIĆ CZY NIE OPTYMALNIEJ BĘDZIE PRZENIEŚĆ TROCHĘ SKRYPTU KAMERY DO `Head` Node'a!
	
	# Kierunek patrzenia gracza
	var forward: Vector3 = -player.global_transform.basis.z
	
	# Zajebałem to z internetu, nie wiem jak to działa.
	# TODO: Trzeba znaleźć opcję zrobienia tego na inspektorze z layersami.
	# Zgaduję, że to z animacjami się robi, tzn. collision shape w animacji przelatuje przez collision shape Tatara i to skasujemy
	var space_state = player.get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var shape = SphereShape3D.new()
	shape.radius = range
	query.shape = shape
	query.transform = player.global_transform
	query.collision_mask = 4  # Warstwa wrogów = `layer 3`, jak coś
	
	var results = space_state.intersect_shape(query)
	
	print("Znaleziono ", results.size(), " potencjalnych celów w zasięgu")
	
	var hit_count = 0
	for result in results:
		var enemy = result.collider
		
		# TODO: TO TEŻ ZAJEBAŁEM Z INTERNETU. 
		# TRZEBA PRZEROBIĆ TO ŻEBY BYŁO ŁATWIEJ I MNIEJ MATEMATYKI,
		# CZYLI NA ReyCast3D Node. Robiłem tak tylko z bronią palną, ale pewnie zasada jest podobna co do broni białej.
		# Sprawdza czy wróg jest w kącie ataku
		var to_enemy: Vector3 = (enemy.global_position - player.global_position).normalized()
		var angle_to_enemy: float = rad_to_deg(forward.angle_to(to_enemy))
		
		if angle_to_enemy <= angle_degrees / 2.0:
			print("Trafiony: ", enemy.name, " za = ", damage)
			
			hit_count += 1
			enemy_hit.emit()  # Sygnał dla hitmarkera
	
	if hit_count > 0:
		print("Trafiono = ", hit_count)
