class_name WalkingPlayerState

extends State

func _physics_update(_delta: float) -> void:
	#Grawitacja
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * _delta
	#Skok - opcjonalnie
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		owner.velocity.y = owner.JUMP_VELOCITY
	#Poruszanie
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var move_direction = (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var current_velocity_plane = Vector2(owner.velocity.x, owner.velocity.z)
	var target_velocity_plane = Vector2(move_direction.x, move_direction.z) * owner.SPEED
	
	#Akceleracja i zatrzymanie sie -> przejście do stanu idle
	if move_direction:
		owner.velocity.x = move_toward(owner.velocity.x, move_direction.x * owner.SPEED, owner.ACCELERATION * _delta)
		owner.velocity.z = move_toward(owner.velocity.z, move_direction.z * owner.SPEED, owner.ACCELERATION * _delta)
	else:
		transition.emit("IdlePlayerState")
		return
	#Drabina
	if owner.is_on_ladder and Input.is_action_pressed("move_forward"):
		transition.emit("LadderPlayerState")
		return
		
	owner.move_and_slide()
