extends CharacterBody3D
## Lepszy (niż wbudowany w Godot) skrypt poruszania się postaci gracza.
##
## Skrypt odpowiada za ruch postaci gracza, jak i ruchu kamery.

signal player_hit
signal player_died

# Zmienne ruchu (możesz je edytować w Inspektorze > player.gd)
## Prędkość poruszania się.
@export var SPEED: float = 5.0
## Wysokość skoku.
@export var JUMP_VELOCITY: float = 4.5
# Zmienne poprawiające sterowanie
## Moc z jaką przyśpiesza gracza.
@export var ACCELERATION: float = 8.0
## Moc z jaką gracz hamuje.
@export var FRICTION: float = 10.0

## Czułość myszy.
@export var MOUSE_SENS: float = 0.3 # 0.5 to zwykle za dużo //ale niemiło, boomer shootery mają 0.5 :(

## Zdrowie gracza
@export var max_health: float = 100.0
var current_health: float = 100.0

## Zmienna pobierająca grawitację z Project Settings.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

## Podpięcie Node'a kamery.
@onready var camera: Camera3D = $Head/Camera3D

# Ograniczenia patrzenia góra-doł (w stopniach (również można je edytować w Inspektorze > player.gd)
@export var MIN_PITCH: float = -90.0
@export var MAX_PITCH: float = 90.0


#Stan playera - czy znajduje sie na drabinie
var is_on_ladder: bool = false

## Blokuje mysz, aby zniknęła z ekranu ("capture") oraz nie pozwala kursorowi wylatywać poza ekran gry.
func _ready() -> void:
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_health = max_health

## Funkcja pozwalająca się graczowi obracać.
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
#func _physics_process(delta: float) -> void:
	#
	## Grawitacja
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
## Nie wiem czy w ogóle skok będzie nam potrzebny(?).
	## Skok, pobranie inputu gracza (spacja).
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	#
	### Pobranie inputu gracza (WSAD).
	#var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#
	### Obliczenie kierunku ruchu (względem obrotu postaci).
	#var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	#
	## W ogóle ciekawostka, domyślny ruch w Godocie obliczany jest w kierunku -Z.
	#
		## Zamiast operować na velocity.x i velocity.z osobno, "rzutujemy" je na płaszczyznę 2D.
	## Dzięki temu znamy dokładny kąt poruszania się gracza.
	#var current_velocity_plane := Vector2(velocity.x, velocity.z)
	#
	## Cel, jaki chcemy osiągnąć (kierunek * prędkość maksymalna).
	#var target_velocity_plane := Vector2(move_direction.x, move_direction.z) * SPEED
	#
	## Poruszanie się i hamowanie.
	#if move_direction:
		## Mały delay w osiągnięciu pełnej prędkości.
		#velocity.x = move_toward(velocity.x, move_direction.x * SPEED, ACCELERATION * delta)
		#velocity.z = move_toward(velocity.z, move_direction.z * SPEED, ACCELERATION * delta)
		## Jeśli gracz wciska klawisze:
		## Przesuwamy W CAŁOŚCI wektor prędkości w stronę celu.
		## To eliminuje drift, bo wektor rośnie prosto w stronę celu, a nie schodkami po X i Z.
		#current_velocity_plane = current_velocity_plane.move_toward(target_velocity_plane, ACCELERATION * delta)
	#else:
		## Po zaprzestaniu wciskania inputu, gracz się jeszcze trochę "ślizga" przed wyhamowaniem do zera.
		#velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		#velocity.z = move_toward(velocity.z, 0, FRICTION * delta)
		## Jeśli gracz puścił klawisze:
		## Wygaszamy prędkość do zera (hamowanie).
		#current_velocity_plane = current_velocity_plane.move_toward(Vector2.ZERO, FRICTION * delta)
	#
	## Przypisujemy obliczoną prędkość z powrotem do zmiennych silnika (velocity).
	#velocity.x = current_velocity_plane.x
	#velocity.z = current_velocity_plane.y
#
	#move_and_slide()

func _got_healed(amount):
	current_health +=amount
	print("Uleczylam cie! Aktualne hp: ", current_health)
	
	

func _got_hit():
	take_damage(10.0)  # Domyślne obrażenia od wroga

func take_damage(amount: float):
	current_health -= amount
	emit_signal("player_hit")
	print("Gracz otrzymał ", amount, " dmg. Pozostało ", current_health, " HP")
	
	if current_health <= 0:
		_die()

func _die():
	emit_signal("player_died")
	print("NIE ŻYJESZ")
	# Tutaj możesz dodać animację śmierci, ekran game over, itp.
	get_tree().reload_current_scene()  # Tymczasowo - restart poziomu
