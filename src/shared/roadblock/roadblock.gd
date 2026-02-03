extends CharacterBody3D
## Niszczalna przeszkoda blokująca drogę gracza.
##
## @experimental

@export var max_health: float = 2.0

var current_health: float = 2.0

func _ready() -> void:
	current_health = max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	print(amount, " dmg", current_health, " HP")
	
	if current_health <= 0:
		_die()

func _die() -> void:
	print("Boom!")
	queue_free()
