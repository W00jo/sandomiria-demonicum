extends CharacterBody3D

## Zmienne ruchu (możesz je edytować w Inspektorze > player.gd)
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
## Zmienne poprawiające sterowanie
@export var ACCELERATION: float = 8.0
@export var FRICTION: float = 10.0

## Czułość myszy
@export var MOUSE_SENS: float = 0.3 # 0.5 to zwykle za dużo

## Zmienna pobierająca grawitację z Project Settings.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera: Camera3D = $Head/Camera3D

## Ograniczenia patrzenia góra-doł (w stopniach (również można je edytować w Inspektorze > player.gd)
@export var MIN_PITCH: float = -90.0
@export var MAX_PITCH: float = 90.0

# Blokuje kursor przy starcie gry
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Sprawdzenie, czy kamera jest przypisana

# Funkcja obsługująca obrót myszką
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# 1. Obrót Ciała (lewo/prawo) - Oś Y
		# Obracamy całe CharacterBody3D
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
		
		# 2. Obrót Kamery (góra/dół) - Oś X.
		# Obracamy TYLKO węzeł kamery
		if camera:
			camera.rotation_degrees.x -= event.relative.y * MOUSE_SENS
			# Ograniczamy obrót góra/dół
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, MIN_PITCH, MAX_PITCH)

## Funkcja odpowiadająca za ruch i fizykę.
func _physics_process(delta: float) -> void:
	# Grawitacja
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Nie wiem czy w ogóle skok będzie nam potrzebny(?).
	# Skok, pobranie inputu gracza (spacja).
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Pobranie inputu gracza (WSAD).
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Obliczenie kierunku ruchu (względem obrotu postaci).
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Przyspieszenie i tarcie.
	if direction:
		# Mały delay w osiągnięciu pełnej prędkości.
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION * delta)
	else:
		# Po zaprzestaniu wciskania inputu, gracz się jeszcze trochę "ślizga" przed wyhamowaniem do zera.
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.z = move_toward(velocity.z, 0, FRICTION * delta)

	move_and_slide()
