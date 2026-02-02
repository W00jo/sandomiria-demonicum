extends Node3D
## System ataku kierunkowego dla krótkiego miecza.
##
## Gracz wybiera kierunek ruchem myszy, blokuje go prawym przyciskiem,
## a następnie atakuje lewym przyciskiem.
##
## @experimental

## Emitowany gdy wróg zostanie trafiony. Używany do hitmarkera w HUD.
signal enemy_hit

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Kierunki ataku dostępne dla gracza.[br]
## Każdy kierunek ma inne statystyki obrażeń i zasięgu.
enum AttackDirection {
	## Cięcie z lewej strony.
	LEFT = 1,
	## Cięcie z prawej strony.
	RIGHT = 2,
	## Overhead - cios z góry, większe obrażenia.
	UP = 3,
	## Pchnięcie - większy zasięg, mniejsze obrażenia.
	DOWN = 4,
}

var current_direction: AttackDirection = AttackDirection.DOWN
var direction_locked: bool = false
var is_attacking: bool = false

## Strefa "martwa" dla myszy (aby uniknąć przypadkowych zmian kierunku).
@export var dead_zone: float = 50.0

## Statystyki obrażeń dla różnych typów ataków.
@export_group("Damage stats")
## Bazowe obrażenia dla cięć bocznych.
@export var base_damage: float = 1
@export var overhead_damage_multiplier: float = 1.5
@export var stab_damage: float = 0.75

## Zasięgi dla różnych typów ataków.
@export_group("Attack ranges")
@export var side_attack_range: float = 1
@export var overhead_attack_range: float = 1
@export var stab_attack_range: float = 1.2

## Określają jak "szeroki" jest atak.
@export_group("Attack areas")
@export var side_attack_angle: float = 90.0
@export var overhead_attack_angle: float = 45.0

var screen_center: Vector2
var accumulated_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		direction_locked = not direction_locked
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_attacking:
			perform_attack()
	
	# Aktualizacja kierunku na podstawie pozycji myszy
	if event is InputEventMouseMotion and not direction_locked:
		accumulated_mouse_pos += event.relative
		accumulated_mouse_pos = accumulated_mouse_pos.limit_length(200.0)
		update_attack_direction(accumulated_mouse_pos)

## @param mouse_pos Akumulowana pozycja względna myszy.
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

## [b]TODO:[/b] Dodać animacje dla każdego kierunku.
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

## Zadaje obrażenia wrogom w stożkowym obszarze przed graczem.[br]
## [br]
## Używa [PhysicsShapeQueryParameters3D] z [SphereShape3D] do wykrycia wrogów,[br]
## a następnie sprawdza czy są w kącie ataku.[br]
## [br]
## [b]TODO:[/b] Przerobić na [RayCast3D] lub [Area3D] z animowanym [CollisionShape3D].[br]
## [br]
## @param range Zasięg ataku (promień sfery).
## @param angle_degrees Kąt stożka ataku w stopniach.
## @param damage Obrażenia do zadania.
func deal_damage_in_area(range: float, angle_degrees: float, damage: float) -> void:
	# TODO: SPRAWDZIĆ CZY NIE OPTYMALNIEJ BĘDZIE PRZENIEŚĆ TROCHĘ SKRYPTU KAMERY DO `Head` Node'a!
	var player = get_parent().get_parent()
	
	# Kierunek patrzenia gracza (przód to -Z w Godocie)
	var forward: Vector3 = -player.global_transform.basis.z
	
	# Wykrywanie wrogów w zasięgu za pomocą PhysicsShapeQuery
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
	
	print("Znaleziono ", results.size(), " celów w zasięgu")
	
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
			
			# Zadaj obrażenia wrogowi
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage)
			
			hit_count += 1
			enemy_hit.emit()  # Sygnał dla hitmarkera
	
	if hit_count > 0:
		print("Trafiono = ", hit_count)
