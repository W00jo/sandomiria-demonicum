class_name LadderPlayerState

extends State

@export var climb_speed: float = 5.0

#W momencie złapania drabiny, zeruje prędkość
func _enter() -> void:
	owner.velocity.x = 0
	owner.velocity.y = 0

#Sprawdzanie co klatke, czy player jest na drabinie
func _physics_update(_delta: float) -> void:
	if not owner.is_on_ladder:
		transition.emit("IdlePlayerState")
		return
	#Pobranie inputów i logika sterowania ruchem w pionie
	var input_dir = Input.get_axis("move_forward", "move_backward")

	if input_dir < 0:
		owner.velocity.y = climb_speed
	elif input_dir > 0:
		owner.velocity.y = -climb_speed
	else:
		owner.velocity.y = 0
	
	owner.velocity.x = 0
	owner.velocity.z = 0

	owner.move_and_slide()
