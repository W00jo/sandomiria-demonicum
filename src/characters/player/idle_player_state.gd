class_name IdlePlayerState

extends State

func _enter() -> void:
	print("stoje")
	owner.velocity.x = 0
	owner.velocity.z = 0

func _physics_update(_delta: float) -> void:
	#Grawitacja
	if not owner.is_on_floor():
		owner.velocity.y -= owner.gravity * _delta
	#Skok - opcjonalny do wywalnia
	if Input.is_action_just_pressed("jump") and owner.is_on_floor():
		owner.velocity.y = owner.JUMP_VELOCITY
	#Hamowanie
	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.FRICTION * _delta)
	owner.velocity.z = move_toward(owner.velocity.z, 0, owner.FRICTION * _delta)
	
	#Przejście do stanu walking
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir.length() > 0:
		transition.emit("WalkingPlayerState")
		return
	
	#Wejscie na drabine
	if owner.is_on_ladder and Input.is_action_pressed("move_forward"):
		transition.emit("LadderPlayerState")
		return

	owner.move_and_slide()
