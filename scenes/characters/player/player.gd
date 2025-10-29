extends CharacterBody3D

## Stała odpowiadająca za podążanie broni w ręce gracza, za kamerą/celownikiem.
const MOUSE_SENS: float = 0.5

# Powstrzymuje kamerę/celownik od przemieszczania się po ekranie.
func _ready () -> void: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
	pass

## Funkcja odpowiadająca za ruch gracza.
func _physics_process(delta) -> void:
	# Grawitacja do ruchu gracza, żeby no nie latać i nie clippować się.
	if not is_on_floor(): velocity += get_gravity() * delta
	## Kontroler ruchu gracza, Vector2 bo to w zasadzie jest 2D. Góra = przód, a dół = do tyłu. Taki psikus.
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	## Matematyka odpowiadająca za samo poruszanie, nie kontrol/przycisk/input.
	var move_direction: Vector3 = (transform.basis * Vector3(input_direction.x, 0, -1 * input_direction.y)).normalized()
	
	if direction:
		#MOVE
	else:
		#STOP
	pass
	

### Stała odpowiadająca za prędkość gracza.
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
